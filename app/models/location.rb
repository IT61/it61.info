class Location < ActiveRecord::Base
  belongs_to :event
  belongs_to :place
end
