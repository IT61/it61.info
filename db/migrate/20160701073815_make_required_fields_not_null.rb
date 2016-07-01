class MakeRequiredFieldsNotNull < ActiveRecord::Migration
  def change
    # User model
    change_column :users, :role, null: false
    change_column :users, :email_reminders, default: false, null: false
    change_column :users, :sms_reminders, default: false, null: false
    change_column :users, :subscribed, default: false, null: false

    # Event model
    change_column :events, :description, null: false
    change_column :events, :organizer_id, null: false
    change_column :events, :place, null: false
  end
end
