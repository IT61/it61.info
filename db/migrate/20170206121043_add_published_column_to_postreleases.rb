class AddPublishedColumnToPostreleases < ActiveRecord::Migration[5.0]
  def up
    add_column :postreleases, :publshed, :boolean, default: false
  end

  def down
    remove_column :postreleases, :published
  end
end
