class AddProfileFieldsToUser < ActiveRecord::Migration
  def change

    add_column :users, :name, :string
    add_column :users, :role, :integer
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :bio, :text
    add_column :users, :phone, :string
    add_column :users, :normalized_phone, :string
    add_column :users, :email_reminders, :boolean
    add_column :users, :sms_reminders, :boolean
    add_column :users, :subscribed, :boolean

    add_index :users, :email_reminders
    add_index :users, :sms_reminders
    add_index :users, :subscribed
    add_index :users, :name

  end
end
