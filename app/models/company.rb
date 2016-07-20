# frozen_string_literal: true
class Company < ApplicationRecord
  validates_presence_of :name, uniqueness: true
end
