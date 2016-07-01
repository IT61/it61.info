class MakeRequiredFieldsNotNull < ActiveRecord::Migration
  def change

    # User model
    change_column_null :users, :role, false
    change_column_null :users, :email_reminders, false, false
    change_column_null :users, :sms_reminders, false, false
    change_column_null :users, :subscribed, false, false

    # Event model
    change_column_null :events, :description, false, false
    change_column_null :events, :organizer_id, false, false
    change_column_null :events, :place, false, false
  end
end