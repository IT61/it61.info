class AddIsSocialAccountsHiddenToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_social_profiles_hidden, :boolean, null: false, default: false
  end
end
