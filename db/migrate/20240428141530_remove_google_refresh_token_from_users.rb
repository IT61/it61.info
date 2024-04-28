class RemoveGoogleRefreshTokenFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :google_refresh_token
  end
end
