class MakePlaceOfAReferenceInEventModel < ActiveRecord::Migration
  def change
    remove_column :events, :place, :string
    add_reference :events, :place, index: true
    add_foreign_key :events, :places
  end
end
