class ParticipantEntryForm < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  enum confidence: { not_sure: 0, sure: 1 }

  validates_presence_of :profession, :reason, :user, :event

  def self.resave_for(user, event)
    entry_form = event.entry_form_for(user)
    save_entry_form(entry_form)
  end
end
