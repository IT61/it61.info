class InsertSocialLinkIntoSocialAccounts < ActiveRecord::Migration
  def change
    add_column :social_accounts, :link, :string
  end
end
