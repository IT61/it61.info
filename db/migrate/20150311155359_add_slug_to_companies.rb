class AddSlugToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :permalink, :string, null: false
    add_index :companies, :permalink, unique: true
  end
end
