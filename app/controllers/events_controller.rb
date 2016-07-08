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
      e.started_at = ep[:started_at]
      e.organizer = current_user
      e.locations += find_locations
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
    params.require(:event).permit(:title, :description, :title_image, :started_at,
      locations: [:extra_info, :title, :address, :latitude, :longitude])
  end

  def find_locations
    res = []
    locations_data = event_params[:locations]
    locations_data.each do |location_data|
      res << new_location_with_place(location_data)
    end
    res
  end

  def new_location_with_place(data)
    place = Place.where(title: data[:title], address: data[:address],
      latitude: data[:latitude], longitude: data[:longitude]).first_or_create

    Location.where(extra_info: data[:extra_info],
      place: data[:place]).first_or_initialize
  end

end
