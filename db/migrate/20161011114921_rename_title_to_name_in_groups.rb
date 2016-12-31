class RenameTitleToNameInGroups < ActiveRecord::Migration[5.0]
  def change
    rename_column :groups, :title, :name
    change_column :groups, :name, :string, null: false
  end
end
