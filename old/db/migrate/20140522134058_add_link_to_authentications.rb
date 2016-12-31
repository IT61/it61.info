class AddLinkToAuthentications < ActiveRecord::Migration
  def change
    add_column :authentications, :link, :string
  end
end
