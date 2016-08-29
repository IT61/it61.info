class RegistrationTypeAsBoolean < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :registration_type, :integer
    add_column :events, :has_closed_registration, :boolean, default: false
  end
end
