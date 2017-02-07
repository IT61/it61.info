class AddPostreleaseIdColumnToMaterials < ActiveRecord::Migration[5.0]
  def up
    add_reference :materials, :postrelease, index: true, foreign_key: true
  end
end
