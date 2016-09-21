class EventsController < ApplicationController
  respond_to :html
  respond_to :json
  respond_to :ics, only: :show
  respond_to :rss, only: :index

  before_action :authenticate_user!, except: [:index, :show, :upcoming, :past]
  before_action :set_event, only: [:show,
                                   :edit,
                                   :participate,
                                   :leave,
                                   :add_to_google_calendar,
                                   :download_ics_file]

  authorize_resource

  def index
    redirect_to_relevant_scope
  end

  def upcoming
    show_events(:upcoming)
  end

  def past
    show_events(:past)
  end

  def unpublished
    show_events(:unpublished, true)
  end

  def show
  end

  def new
    @event ||= Event.new
    @event.build_place
  end

  def edit
  end

  def update
    @event = Event.find(params[:id])
    @event.assign_attributes(event_params.except(:title_image, :place))
    @event.set_place(place_params)
    if @event.save
      flash[:success] = t("flashes.event_successfully_updated")
      render json: {success: true, url: event_url(@event)}
    else
      render json: {success: false, errors: @event.errors.messages}
    end
  end

  def create
    @event = current_user.create_event(event_params, place_params)

    if @event.save
      flash[:success] = t("flashes.event_successfully_created")
      render json: {success: true, url: event_url(@event)}
    else
      render json: {success: false, errors: @event.errors.messages}
    end
  end

  def participate
    @event.new_participant!(current_user) if @event.able_to_participate?
    redirect_to @event
  end

  def leave
    participation = @event.participation_for(current_user)
    EventParticipation.destroy_if_exists(participation)
    redirect_to @event
  end

  def publish
    @event = Event.find(params[:id])
    @event.publish!
    flash[:success] = t("flashes.event_successfully_published")
    redirect_to @event
  end

  def add_to_google_calendar
    success = GoogleService.add_event_to_calendar(current_user, @event)

    if success
      redirect_to event_path(@event), notice: t("flashes.event_successfully_added_to_google_calendar")
    else
      redirect_to event_path(@event), error: t("flashes.event_failure_to_add_to_google_calendar")
    end
  end

  def download_ics_file
    calendar = IcsService.to_ics_calendar(@event, event_url(@event))
    options = IcsService.file_options_for(@event)
    send_data calendar, options
  end

  private

  def set_event
    @event = Event.eager_load(:place, :organizer).find(Event.id_from_permalink(params[:id]))
  end

  def show_events(scope, all = false)
    @events = Event.send(scope).paginate(page: params[:page], per_page: Settings.per_page.events).eager_load(:place)
    @events = @events.published unless all
    @scope = scope

    view = request.xhr? ? "events/cards/_card" : "events/index"
    respond_with @events do |f|
      f.html { render view, layout: !request.xhr? }
    end
  end

  def redirect_to_relevant_scope
    path = Event.published.upcoming.count.positive? ? upcoming_events_path : past_events_path
    redirect_to path
  end

  def event_params
    permitted_attrs = [
        :title,
        :description,
        :title_image,
        :link,
        :place_id,
        :organizer_id,
        :started_at,
        :has_closed_registration
    ]
    params.require(:event).permit(*permitted_attrs)
  end

  def place_params
    place_attrs = [:title, :address, :latitude, :longitude]
    params.require(:place).permit(*place_attrs)
  end
end
