class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.belongs_to :event
      t.belongs_to :place
      t.string :extra_info
      t.timestamps null: false
    end

    add_index :locations, [ :event_id, :place_id, :extra_info ], unique: true
  end
end
