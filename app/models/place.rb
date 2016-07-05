class Place < ActiveRecord::Base
  has_many :locations
  has_many :events, through: :locations
end
