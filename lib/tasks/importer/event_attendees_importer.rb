module EventsAttendeesImporter
  def import_events_attendees
    puts "Importing event attendees"

    use_old_db
    ep = ActiveRecord::Base.connection.execute("SELECT * FROM event_attendees")
    use_new_db

    for i in 0...ep.count do
      row = ep.get_row(i)

      event_attendee = EventsAttendee.new(
        event_id: row.get("event_id"),
        user_id: row.get("user_id")
      )

      begin
        event_attendee.save!
      rescue => e
        puts "Failed to save [#{event_attendee.user_id}] #{event_attendee.event_id}: #{e.message}"
      end
    end
  end
end
