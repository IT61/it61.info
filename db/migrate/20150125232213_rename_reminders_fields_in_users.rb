class RenameRemindersFieldsInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :send_email_reminders, :email_reminders
    rename_column :users, :send_sms_reminders, :sms_reminders
  end
end
