class AddIsSocialAccountsHiddenToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :is_social_profiles_hidden, :boolean, null: false, default: false
  end
end
