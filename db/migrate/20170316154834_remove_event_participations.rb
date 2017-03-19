class RemoveEventParticipations < ActiveRecord::Migration[5.0]
  def change
    execute %{
INSERT INTO events_attendees(user_id, event_id)
SELECT user_id, event_id FROM event_participations;
}
    drop_table :event_participations
    drop_table :registrations
  end
end
