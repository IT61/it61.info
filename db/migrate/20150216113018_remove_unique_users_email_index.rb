class RemoveUniqueUsersEmailIndex < ActiveRecord::Migration
  def change
    remove_index :users, :email
    add_index :users, :email
  end
end
