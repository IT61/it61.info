class EventsRemoveReferenceToPlace < ActiveRecord::Migration
  def change
    remove_column :events, :place_id, :integer
    remove_column :events, :place_extra_info, :string
  end
end
