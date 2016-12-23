class AddIsFreshToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :is_fresh, :boolean, default: true, null: false
  end
end
