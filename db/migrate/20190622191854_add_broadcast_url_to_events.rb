class AddBroadcastUrlToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :broadcast_url, :string
  end
end
