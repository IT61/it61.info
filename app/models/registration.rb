class Registration < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  enum confidence: { not_sure: 0, sure: 1 }

  validates_presence_of :profession, :reason, :user, :event

end
