class CreateEventsAttendees < ActiveRecord::Migration[5.0]
  def change
    create_table :events_attendees do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end

    add_index :events_attendees, [ :user_id, :event_id ], unique: true
  end
end
