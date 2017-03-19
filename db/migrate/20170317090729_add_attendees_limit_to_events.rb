class AddAttendeesLimitToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :has_attendees_limit, :boolean, null: false, default: false
    rename_column :events, :participants_limit, :attendees_limit
    change_column :events, :attendees_limit, :integer, null: false, default: -1
  end
end
