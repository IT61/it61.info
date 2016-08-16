class ChangeEventPlaceRelation < ActiveRecord::Migration[5.0]
  def change
    drop_table :events_places

    add_reference :events, :place, index: true, foreign_key: true
  end
end
