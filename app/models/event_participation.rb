class EventParticipation < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :user_id, uniqueness: { scope: :event_id }

  def self.destroy_if_exists(participation)
    EventParticipation.destroy(participation) unless participation.blank?
  end
end
