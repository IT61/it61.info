class CreatePlaces < ActiveRecord::Migration[5.0]
  def change
    create_table :places do |t|
      t.string :title, index: true, null: false
      t.string :address, index: true, null: false
      t.float :latitude # Широта
      t.float :longitude # Долгота
      t.timestamps null: false
    end

    add_index :places, [:title, :address, :latitude, :longitude], unique: true
  end
end
