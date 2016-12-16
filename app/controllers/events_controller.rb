class EventsController < ApplicationController
  respond_to :json, only: [:create]
  respond_to :ics, only: :show
  respond_to :rss, only: :index

  before_action :authenticate_user!, except: [:index, :show, :upcoming, :past]
  before_action :set_event, only: [:show, :edit, :publish]
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

  private

  def set_event
    @event = Event.find(params[:id])
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
