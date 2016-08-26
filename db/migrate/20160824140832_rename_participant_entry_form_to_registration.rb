class RenameParticipantEntryFormToRegistration < ActiveRecord::Migration[5.0]
  def change
    rename_table :participant_entry_forms, :registrations
  end
end
