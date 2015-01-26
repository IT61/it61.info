class AddFieldsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :subscribers_notification_send, :boolean, default: false
    add_column :events, :published_at, :datetime

    add_index :events, :published_at
    add_index :events, :subscribers_notification_send
  end
end
