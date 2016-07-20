class AddDefaultForRegtypeOfEvent < ActiveRecord::Migration
  def change
    change_column :events, :registration_type, :integer, default: 0
  end
end
