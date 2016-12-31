class Place < ApplicationRecord
  has_many :events

  validates :address, presence: true

  def full_address
    [address, title].join(", ")
  end
end
