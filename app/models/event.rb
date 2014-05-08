class Event < ActiveRecord::Base
  belongs_to :organizer, class_name: 'User'

  validates :title, presence: true
  validates :organizer, presence: true

  scope :ordered_desc, -> { order(started_at: :desc) }
end
