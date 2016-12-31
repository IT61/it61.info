class AddLinkFieldToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :link, :string
  end
end
