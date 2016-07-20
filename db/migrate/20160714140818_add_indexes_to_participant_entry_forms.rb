class AddIndexesToParticipantEntryForms < ActiveRecord::Migration
  def change
    remove_index :participant_entry_forms, :user_id
    remove_index :participant_entry_forms, :event_id
    add_index :participant_entry_forms, [:user_id, :event_id], :unique => true
  end
end
