class EventsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
  end

  def new
    @event ||= Event.new
  end

  def create
    ep = event_params
    @event = Event.create do |e|
      e.title = ep[:title]
      e.title_image = ep[:title_image]
      e.description = ep[:description]
      e.started_at = ep[:started_at]
      e.organizer = current_user
      e.locations += [new_location_with_place]
    end

    if @event.persisted?
      redirect_to action: :index
    else
      flash[:errors] = @event.errors.messages
      render 'new'
    end
  end

  def places
    title = params[:title]
    address = params[:address]
    # byebug
    render json: {'lol': true}
  end

  private

  def event_params
    params.require(:event).permit :title, :description, :title_image, :started_at,
      :extra_info, :title, :address, :latitude, :longitude, :place_title
  end

  def new_location_with_place
    place = Place.where(title: event_params[:place_title], address: event_params[:address],
      latitude: event_params[:latitude], longitude: event_params[:longitude]).first_or_create

    Location.where(extra_info: event_params[:extra_info],
      place: place).first_or_create
  end
end
