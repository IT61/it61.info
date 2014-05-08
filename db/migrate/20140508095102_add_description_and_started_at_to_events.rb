class AddDescriptionAndStartedAtToEvents < ActiveRecord::Migration
  def change
    add_column :events, :description, :text
    add_column :events, :started_at, :datetime
  end
end
