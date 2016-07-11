class EventsController < ApplicationController

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
      e.started_at = ep[:started_at_date] # add started_at_time
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

  private

  def event_params
    params.require(:event).permit :title, :description, :title_image, :started_at,
      :extra_info, :title, :address, :latitude, :longitude
  end

  def new_location_with_place
    place = Place.where(title: params[:title], address: params[:address],
      latitude: params[:latitude], longitude: params[:longitude]).first_or_create

    Location.where(extra_info: params[:extra_info],
      place: place).first_or_initialize
  end

end
