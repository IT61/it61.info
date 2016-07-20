# frozen_string_literal: true
class Location < ApplicationRecord
  belongs_to :event
  belongs_to :place
end
