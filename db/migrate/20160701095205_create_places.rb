class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :title, index: true, null: false
      t.string :address, index: true, null: false
      t.float :latitude # Широта
      t.float :longitude # Долгота
      t.timestamps null: false
    end
  end
end
