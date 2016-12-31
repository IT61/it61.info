class AddPublishedToEvents < ActiveRecord::Migration
  def change
    add_column :events, :published, :boolean, default: false
  end
end
