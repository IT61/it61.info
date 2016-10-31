class AddPlaceExtraInfoColumnToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :place_extra_info, :string
  end
end
