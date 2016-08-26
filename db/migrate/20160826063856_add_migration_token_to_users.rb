class AddMigrationTokenToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :migration_token, :string
  end
end
