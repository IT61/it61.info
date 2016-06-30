class CreateEventParticipations < ActiveRecord::Migration
  def change
    create_table :event_participations do |t|
      t.references :user, index: true
      t.references :event, index: true
      t.timestamp
    end
  end
end
