class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.text :title, null: false
      t.text :description
      t.integer :founder_id, null: false
      t.string :logo_image
      t.text :contacts
      t.timestamps
    end
    add_index :companies, :founder_id
  end
end
