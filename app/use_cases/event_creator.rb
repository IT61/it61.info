class EventCreator

  def create(params, current_user)
    ep = event_params(params)
    Event.create do |e|
      e.title = ep[:title]
      e.title_image = ep[:title_image]
      e.description = ep[:description]
      e.started_at = parse_date_time ep
      e.link = ep[:link]
      e.organizer = current_user
      e.locations += [new_location_with_place(ep)]
    end
  end

  def update(event, params, current_user)
    ep = event_params(params)

    event.title = ep[:title]
    event.title_image = ep[:title_image]
    event.description = ep[:description]
    event.started_at = parse_date_time ep
    event.organizer = current_user
    event.link = ep[:link]

    update_place_location(ep, event.locations)

    event.save
    event
  end

  private

  def event_params(params)
    permitted_attrs = [
        :title,
        :description,
        :title_image,
        :link,
        :started_at_date,
        :started_at_time,
        :place_title,
        :address,
        :latitude,
        :longitude,
    ]
    params.require(:event).permit(*permitted_attrs)
  end

  def new_location_with_place(event_params)
    place = Place.where(title: event_params[:place_title], address: event_params[:address],
                        latitude: event_params[:latitude], longitude: event_params[:longitude]).first_or_create

    Location.where(place: place).first_or_create
  end

  def update_place_location(event_params, locations)

    if locations.count != 1
      return places
    end
    location = locations[0]
    place = location.place

    place.title = event_params[:place_title]
    place.address = event_params[:address]
    place.latitude = event_params[:latitude]
    place.longitude = event_params[:longitude]
    place.save
  end

  def parse_date_time(event_params)
    Time.new(event_params["started_at_date(1i)"].to_i, event_params["started_at_date(2i)"].to_i, event_params["started_at_date(3i)"].to_i,
             event_params["started_at_time(4i)"].to_i, event_params["started_at_time(5i)"].to_i, event_params["started_at_time(6i)"].to_i)
  end
end