class MakeTitleNullable < ActiveRecord::Migration[5.0]
  def change
    change_column_null :places, :title, null: true
  end
end
