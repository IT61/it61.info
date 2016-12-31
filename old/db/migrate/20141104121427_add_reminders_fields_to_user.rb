class AddRemindersFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :send_email_reminders, :boolean, default: true
    add_column :users, :send_sms_reminders, :boolean, default: false
    add_index :users, :send_email_reminders
    add_index :users, :send_sms_reminders
  end
end