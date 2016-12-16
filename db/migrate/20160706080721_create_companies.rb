class CreateCompanies < ActiveRecord::Migration[5.0]
  def change
    create_table :companies do |t|
      t.string :name, null: false, index: true, unique: true
      t.text :description
      t.string :url
      t.string :logo

      t.timestamps null: false
    end
  end
end
