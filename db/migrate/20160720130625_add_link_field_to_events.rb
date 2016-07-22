class AddLinkFieldToEvents < ActiveRecord::Migration
  def change
    add_column :events, :link, :string
  end
end
