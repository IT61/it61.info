class IcsService
  # rubocop:disable Metrics/AbcSize
  def to_ics_calendar(event, event_url)
    calendar = Icalendar::Calendar.new
    place = event.places.first
    tzid = "Europe/Moscow"

    calendar.event do |e|
      e.dtstart = Icalendar::Values::DateTime.new event.started_at, "tzid" => tzid
      e.dtend   = Icalendar::Values::DateTime.new event.started_at, "tzid" => tzid
      e.summary = event.title
      e.description = event.description
      e.location = event.places.first.address
      e.geo = [place.latitude, place.longitude]
      e.uid = e.url = event_url
    end

    calendar.publish
    calendar
  end
end
