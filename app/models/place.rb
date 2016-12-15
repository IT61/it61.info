class Place < ApplicationRecord
  has_many :events

  validates :title, presence: true
  validates :address, presence: true

  def full_address
    [address, title].join(", ")
  end
end
