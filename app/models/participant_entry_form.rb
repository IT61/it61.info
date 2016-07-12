class ParticipantEntryForm < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  validates_presence_of :profession, :reason, :user, :event
end
