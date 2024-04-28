class Group < ApplicationRecord
  has_and_belongs_to_many :users

  validates :name, presence: true, uniqueness: true

  enum kind: {
    general: 0,
    developers: 1,
    organizers: 2
  }
end
