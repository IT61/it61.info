# frozen_string_literal: true
class Company < ActiveRecord::Base
  validates_presence_of :name, uniqueness: true
end
