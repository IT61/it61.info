class AddKindToGroup < ActiveRecord::Migration[5.0]
  def up
    add_column :groups, :kind, :integer, null: false, default: 0
  end

  def down
    remove_column :groups, :kind
  end
end
