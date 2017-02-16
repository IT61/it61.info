class IcsService
  class << self
    # rubocop:disable Metrics/AbcSize
    def to_ics_calendar(event)
      calendar = Icalendar::Calendar.new

      place = event.place
      date_start = Icalendar::Values::DateTime.new event.started_at, tzid: Time.zone.name
      calendar.event do |e|
        e.dtstart = date_start
        e.dtend = date_start
        e.summary = event.title
        e.description = event.description
        e.location = place.full_address
        e.geo = [place.latitude, place.longitude]
      end

      calendar.publish
      calendar.to_ical
    end

    def file_options_for(event)
      {
        filename: filename(event),
        type: ics_type,
      }
    end

    private

    def filename(event)
      filename = sanitize_filename(event.title)
      "#{filename}.ics"
    end

    def ics_type
      "application/ics"
    end

    def sanitize_filename(filename)
      filename.gsub(/[^0-9A-zа-яА-Я.\-]/, "_")
    end
  end
end
