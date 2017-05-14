class RemoveEventParticipations < ActiveRecord::Migration[5.0]
  def change
    execute %{
INSERT INTO events_attendees(user_id, event_id, created_at, updated_at)
SELECT user_id, event_id, current_timestamp, current_timestamp FROM event_participations;
}
    drop_table :event_participations
    drop_table :registrations
  end
end
