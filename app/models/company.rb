class Company < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
