module SocialAccountsImporter
  def import_social_accounts
    puts "Importing social accounts"

    use_old_db
    social_accounts = ActiveRecord::Base.connection.execute("SELECT * FROM authentications")
    use_new_db

    for i in 0...social_accounts.count do
      row = social_accounts.get_row(i)

      # for social accounts we save all fields as is
      social_account = SocialAccount.new
      row.fields.each do |f|
        value = row.get(f)
        # rename vk => vkontakte
        value = "vkontakte" if value == "vk"

        social_account.write_attribute(f, value)
      end

      begin
        social_account.save!
      rescue => e
        puts "Failed to save #{social_account.uid} for #{social_account.user_id}: #{e.message} because of: #{social_account.errors.full_messages.join(', ')}"
      end
    end
  end
end
