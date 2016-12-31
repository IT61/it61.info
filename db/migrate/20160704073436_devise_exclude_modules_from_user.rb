class DeviseExcludeModulesFromUser < ActiveRecord::Migration[5.0]
  def change
    # Database authenticatable
    remove_column :users, :encrypted_password, :string

    # Recoverable
    remove_column :users, :reset_password_token, :string
    remove_column :users, :reset_password_sent_at, :datetime

    # OmniAuthable
    remove_column :users, :provider, :string
    remove_column :users, :uid, :string
  end
end
