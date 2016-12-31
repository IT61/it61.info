class AddDefaultForRegtypeOfEvent < ActiveRecord::Migration[5.0]
  def change
    change_column :events, :registration_type, :integer, default: 0
  end
end
