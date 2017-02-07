class AddProcessedToMaterial < ActiveRecord::Migration[5.0]
  def change
    add_column :materials, :processed, :boolean, default: false
  end
end
