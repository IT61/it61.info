class IcsService
  class << self

    # rubocop:disable Metrics/AbcSize
    def to_ics_calendar(event, event_url)
      calendar = Icalendar::Calendar.new
      place = event.place
      tzid = "Europe/Moscow"

      calendar.event do |e|
        e.dtstart = Icalendar::Values::DateTime.new event.started_at, "tzid" => tzid
        e.dtend   = Icalendar::Values::DateTime.new event.started_at, "tzid" => tzid
        e.summary = event.title
        e.description = event.description
        e.location = place.full_address
        e.geo = [place.latitude, place.longitude]
        e.uid = e.url = event_url
      end

      calendar.publish
      calendar.to_ical
    end

    def file_options_for(event)
      {
          filename: filename(event),
          type: "application/ics"
      }
    end

    private

    def filename(event)
      "#{event.title}.ics"
    end

  end
end
