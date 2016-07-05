class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.belongs_to :event
      t.belongs_to :place
      t.string :extra_info
      t.timestamps null: false
    end
  end
end
