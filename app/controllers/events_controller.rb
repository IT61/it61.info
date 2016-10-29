class EventsController < ApplicationController
  respond_to :html
  respond_to :ics, only: :show
  respond_to :rss, only: :index

  before_action :authenticate_user!, except: [:index, :show, :upcoming, :past]
  before_action :set_event, only: [:show, :edit, :publish]

  authorize_resource

  def index
  end

  def show
  end

  def new
    @event = Event.new
    @event.build_place
  end

  def create
    @event = Event.create(event_params)
    respond_with(@event)
  end

  def edit
  end

  def update
    @event = Event.update(event_params)
    respond_with(@event)
  end

  private

  def set_event
    @event = Event.id_from_permalink(event_params[:id])
  end

  def event_params
    permitted_attrs = [
      :title,
      :description,
      :title_image,
      :link,
      :started_at,
      :has_closed_registration,
      :organizer_id,
      :place_id,
    ]
    params.require(:event).permit(*permitted_attrs)
  end
end
