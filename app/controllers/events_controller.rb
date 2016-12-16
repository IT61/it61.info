class EventsController < ApplicationController
  respond_to :json, only: [:create]
  respond_to :ics, only: :ics
  respond_to :rss, only: :index

  before_action :set_event, only: [:show]
  load_and_authorize_resource

  def index
    @events = Event.ordered_desc
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
    @events = Event.past
    render :index
  end

  def upcoming
    @events = Event.upcoming
    render :index
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
