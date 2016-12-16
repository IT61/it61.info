class RefactorLocationsToEventsPlaces < ActiveRecord::Migration[5.0]
  def change
    remove_column :locations, :extra_info, :string
    rename_table :locations, :events_places
  end
end
