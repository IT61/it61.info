class AddPublishedToGoogleCalendarToEvents < ActiveRecord::Migration
  def change
    add_column :events, :published_to_google_calendar, :boolean, default: false
  end
end
