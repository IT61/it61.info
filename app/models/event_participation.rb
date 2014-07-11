class EventParticipation < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :user
  belongs_to :event

  validates :user_id, uniqueness: { scope: :event_id }
end
