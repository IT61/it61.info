# frozen_string_literal: true
class Place < ApplicationRecord
  has_and_belongs_to_many :events

  def full_address
    [title, address].compact.join(", ")
  end
end
