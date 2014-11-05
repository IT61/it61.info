class AddGoogleCalendarIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :google_calendar_id, :string
  end
end
