class Registration < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  enum confidence: { not_sure: 0, sure: 1 }

  validates :profession, presence: true
  validates :reason, presence: true
  validates :user, presence: true
  validates :event, presence: true
end
