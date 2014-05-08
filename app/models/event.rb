class Event < ActiveRecord::Base
  belongs_to :organizer, class_name: 'User'

  has_many :event_participations
  has_many :participants, class_name: 'User', through: :event_participations, source: :user

  validates :title, presence: true
  validates :organizer, presence: true

  scope :ordered_desc, -> { order(started_at: :desc) }

  def user_participated?(user)
    user && event_participations.find_by(user_id: user.id)
  end

  def participation_for(user)
    event_participations.find_by(user_id: user.id)
  end
end
