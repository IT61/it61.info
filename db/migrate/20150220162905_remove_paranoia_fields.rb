class RemoveParanoiaFields < ActiveRecord::Migration
  def change
    remove_column :events, :deleted_at
    remove_column :users, :deleted_at
    remove_column :event_participations, :deleted_at
  end
end
