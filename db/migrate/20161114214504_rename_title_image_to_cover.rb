class RenameTitleImageToCover < ActiveRecord::Migration[5.0]
  def change
    rename_column :events, :title_image, :cover
  end
end
