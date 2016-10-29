module EventParticipationsImporter
  def import_event_participations
    puts "Importing event participants"

    use_old_db
    ep = ActiveRecord::Base.connection.execute("SELECT * FROM event_participations")
    use_new_db

    for i in 0...ep.count do
      row = ep.get_row(i)

      event_participation = EventParticipation.new(
        event_id: row.get("event_id"),
        user_id: row.get("user_id")
      )

      begin
        event_participation.save!
      rescue => e
        puts "Failed to save [#{event_participation.user_id}] #{event_participation.event_id}: #{e.message} because of: #{event_participation.errors.full_messages.join(', ')}"
      end
    end
  end
end
