class EventsController < ApplicationController
  respond_to :json, only: [:create]
  respond_to :ics, only: :ics
  respond_to :rss, only: :index

  before_action :set_event, only: [:show]
  load_and_authorize_resource

  def index
    scoped(:ordered_desc)
  end

  def show; end

  def new
    @event = Event.new
    @event.build_place
  end

  def create
    @event = Event.create(event_params.merge(organizer: current_user))
    if @event.persisted?
      respond_with(@event, location: -> { event_path(@event) }, status: 302)
    else
      respond_with(@event)
    end
  end

  def edit; end

  def update
    @event = Event.update(event_params)
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
    calendar = IcsService.to_ics_calendar(@event, event_url(@event))
    options = IcsService.file_options_for(@event)
    send_data calendar, options
  end

  private

  def scoped(scope)
    @events = Event.includes(:place).send(scope).paginate(page: params[:page], per_page: Settings.per_page.events)
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
