module EventsImporter
  require "geocoder"

  FIELDS_TO_SKIP = [
    "published_to_google_calendar",
    "google_calendar_id"
  ].freeze

  PREDEFINED_PLACES = [
    { key: "Южный IT-парк", id: 3 },
    { key: "MESTO", id: 2 },
    { key: "Место", id: 2 }
  ]

  def import_events
    puts "Importing events"
    Geocoder.configure(lookup: :yandex)

    use_old_db
    events = ActiveRecord::Base.connection.execute("SELECT * FROM events")
    use_new_db

    for i in 0...events.count do
      row = events.get_row(i)

      # for events we save all fields as is
      event = Event.new
      row.fields.each do |f|
        next if FIELDS_TO_SKIP.include?(f)

        if f === "place"
          raw_place = row.get("place")
          next if raw_place.blank?

          # try to find in predefined places
          PREDEFINED_PLACES.each do |p|
            unless raw_place.index(p[:key]).nil?
              event.place = Place.find(p[:id])
              break
            end
          end

          # set the correct Place
          if event.place.blank?
            suggested_places = Geocoder.search(raw_place, params: { countrycodes: "ru" })
            suggested_places.each do |suggested_place|
              place = Place.find_by(latitude: suggested_place.latitude, longitude: suggested_place.longitude)
              event.place = place if place.present?
            end

            # still no place? Save it as is
            event.place = Place.find_or_create_by(address: raw_place)
          end
        elsif f === "title_image"
          event.write_attribute("cover", row.get(f))
        else
          event.write_attribute(f, row.get(f))
        end
      end

      begin
        event.save!
      rescue => e
        puts "Failed to save [#{event.id}] #{event.title}: #{e.message}"
      end
    end
  end
end
