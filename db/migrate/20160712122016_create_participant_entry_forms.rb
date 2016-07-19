class CreateParticipantEntryForms < ActiveRecord::Migration
  def change
    create_table :participant_entry_forms do |t|
      t.belongs_to :user, index: true, null: false
      t.belongs_to :event, index: true, null: false
      t.text :reason, null: false
      t.string :profession, null: false
      t.text :suggestions
      t.integer :confidence, null: false
      t.timestamps null: false
    end
  end
end
