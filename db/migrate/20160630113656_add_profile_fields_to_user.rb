class AddProfileFieldsToUser < ActiveRecord::Migration
  def change

    add_column :users, :name, String, index: true
    add_column :users, :role, Integer
    add_column :users, :first_name, String
    add_column :users, :last_name, String
    add_column :users, :bio, :text
    add_column :users, :phone, String
    add_column :users, :normalized_phone, String
    add_column :users, :email_reminders, Boolean, index: true
    add_column :users, :sms_reminders, Boolean, index: true
    add_column :users, :subscribed, Boolean, index: true

  end
end
