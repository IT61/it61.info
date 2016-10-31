class InsertSocialLinkIntoSocialAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :social_accounts, :link, :string
  end
end
