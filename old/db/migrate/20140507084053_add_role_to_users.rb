class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :integer, index: true
  end
end
