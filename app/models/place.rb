# frozen_string_literal: true
class Place < ApplicationRecord
  has_many :locations
  has_many :events, through: :locations

  def full_address
    [address, title].compact.join(", ")
  end
end
