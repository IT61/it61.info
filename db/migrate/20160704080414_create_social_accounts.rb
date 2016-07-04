class CreateSocialAccounts < ActiveRecord::Migration
  def change
    create_table :social_accounts do |t|
      t.belongs_to :user, index: true

      ## OmniAuthable
      t.string :provider, null: false
      t.string :uid, null: false

      t.timestamps null: false
    end
  end
end
