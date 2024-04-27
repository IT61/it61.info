class DropInstagramCache < ActiveRecord::Migration[6.0]
  def change
    drop_table :instagram_cache, if_exists: true
  end
end
