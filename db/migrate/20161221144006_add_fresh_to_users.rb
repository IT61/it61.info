class AddFreshToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :fresh, :boolean, default: true, null: false
  end
end
