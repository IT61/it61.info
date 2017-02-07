class CreateMaterials < ActiveRecord::Migration[5.0]
  def change
    create_table :materials do |t|
      t.string  :url, null: false
      t.jsonb   :raw_info, default: "{}"
    end
  end
end
