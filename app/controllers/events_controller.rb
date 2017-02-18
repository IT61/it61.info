class EventsController < ApplicationController
  respond_to :json, only: [:create]
  respond_to :ics, only: :ics
  respond_to :rss, only: :feed

  load_and_authorize_resource
  skip_authorize_resource only: :feed

  def index
    if request.format.rss?
      feed
    else
      scoped(:ordered_desc)
    end
  end

  def feed
    @events = Event.includes(:organizer).published.ordered_desc
    respond_to do |format|
      format.rss { render "feed.rss.builder", layout: false }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.ics { ics }
    end
  end

  def new
    @event = Event.new
    @event.build_place
  end

  def create
    @event = Event.create!(event_params.merge(organizer: current_user))
    respond_to do |format|
      format.html { respond_with(@event) }
      format.json {
        if @event.save
          render json: { eventPath: event_path(@event) }, status: 302
        else
          render json: { errors: @event.errors.full_messages }, status: 422
        end
      }
    end
  end

  def edit; end

  def update
    @event.update(event_params)
    respond_with(@event)
  end

  def past
    scoped(:past)
  end

  def upcoming
    scoped(:upcoming)
  end

  def add
    success = GoogleService.add_event_to_calendar(current_user, @event)

    if success
      redirect_to @event, notice: t("flashes.event_successfully_added_to_google_calendar")
    else
      redirect_to @event, error: t("flashes.event_failure_to_add_to_google_calendar")
    end
  end

  def ics
    send_data @event.to_ical, @event.ical_options
  end

  def leave
    @event.participants.destroy(current_user)
    render :show
  end

  def participate
    unless @event.participants.include?(current_user)
      @event.participants << current_user
      @event.save
    end
    render :show
  end

  def publish
    @event.publish!
    render :show
  end

  def unpublish
    @event.unpublish!
    render :show
  end

  private

  def scoped(scope)
    @events = Event.includes(:place).send(scope).published.paginate(page: params[:page], per_page: Settings.per_page.events)
    view = request.xhr? ? "events/_card" : "events/index"
    respond_with @events do |f|
      f.html { render view, layout: !request.xhr?, locals: { events: @events } }
    end
  end

  def set_event
    @event = Event.includes(:participants).find(params[:id])
  end

  def event_params
    permitted_attrs = [
      :id,
      :title,
      :description,
      :cover,
      :link,
      :started_at,
      :has_closed_registration,
      :organizer_id,
      :place_id,
      place_attributes: [
        :id,
        :title,
        :address,
        :latitude,
        :longitude,
      ],
    ]
    params.require(:event).permit(*permitted_attrs)
  end
end
