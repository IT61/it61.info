class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.string :title, null: false, index: true
      t.timestamps
    end
  end
end
