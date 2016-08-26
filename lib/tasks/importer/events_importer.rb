module EventsImporter
  require "geocoder"

  FIELDS_TO_SKIP = [
    "published_to_google_calendar",
    "google_calendar_id"
  ].freeze

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
          # set the correct Place
          suggested_places = Geocoder.search(row.get('place'), params: { countrycodes: "ru" })
          suggested_places.each do |suggested_place|
            place = Place.find_by(latitude: suggested_place.latitude, longitude: suggested_place.longitude)
            event.place = place if place.present?
          end
        else
          event.write_attribute(f, row.get(f))
        end
      end

      begin
        event.save!
      rescue Exception => e
        puts "Failed to save [#{event.id}] #{event.title}: #{e.message} because of: #{event.errors.full_messages.join(', ')}"
      end
    end
  end
end
