module UsersImporter
  FIELDS = [
    "id",
    "email",
    "created_at", "updated_at",
    "name", "first_name", "last_name",
    "role", "bio", "phone", "normalized_phone",
    "email_reminders", "sms_reminders",
    "subscribed"
  ].freeze

  def import_users
    puts "Importing users"

    use_old_db
    users = ActiveRecord::Base.connection.execute("SELECT * FROM users")
    use_new_db

    for i in 0...users.count do
      row = users.get_row(i)

      email = row.get("email")
      has_password = row.get("crypted_password").present?

      user = User.new
      FIELDS.each do |field_name|
        user.write_attribute(field_name, row.get(field_name))
      end

      # create migration token
      if has_password
        user.write_attribute("migration_token", SecureRandom.hex)
      end

      begin
        user.save!
      rescue => e
        puts "Failed to save [#{user.id}] #{user.full_name}: #{e.message}"
      end
    end
  end
end
