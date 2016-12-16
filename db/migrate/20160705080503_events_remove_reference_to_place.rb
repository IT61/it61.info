class EventsRemoveReferenceToPlace < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :place_id, :integer
    remove_column :events, :place_extra_info, :string
  end
end
