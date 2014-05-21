class AddTitleImageToEvents < ActiveRecord::Migration
  def change
    add_column :events, :title_image, :string
  end
end
