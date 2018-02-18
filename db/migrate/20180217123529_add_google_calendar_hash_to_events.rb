class AddGoogleCalendarHashToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :google_calendar_hash, :string
  end
end
