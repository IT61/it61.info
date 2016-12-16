class ChangeNameForCompany < ActiveRecord::Migration[5.0]
  def change
    change_column :companies, :name, :string, null: false

    remove_index :companies, :name
    add_index :companies, :name, unique: true
  end
end
