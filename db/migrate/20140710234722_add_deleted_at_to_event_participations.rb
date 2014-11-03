class AddDeletedAtToEventParticipations < ActiveRecord::Migration
  def change
    add_column :event_participations, :deleted_at, :datetime
    add_index :event_participations, :deleted_at
  end
end
