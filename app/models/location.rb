# frozen_string_literal: true
class Location < ActiveRecord::Base
  belongs_to :event
  belongs_to :place
end
