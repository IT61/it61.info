class Place < ApplicationRecord
  has_many :events

  validates_presence_of :title, :address

  def full_address
    [address, title].join(", ")
  end
end
