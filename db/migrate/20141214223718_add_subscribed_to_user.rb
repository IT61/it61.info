class AddSubscribedToUser < ActiveRecord::Migration
  def up
    add_column :users, :subscribed, :boolean, default: true
    add_index :users, :subscribed
  end

  def down
    remove_column :users, :subscribed
  end
end
