class AddPlaceExtraInfoColumnToEvent < ActiveRecord::Migration
  def change
    add_column :events, :place_extra_info, :string
  end
end
