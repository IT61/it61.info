# frozen_string_literal: true
class Authentication < ActiveRecord::Base
  belongs_to :user
  validates :uid, uniqueness: { scope: :provider }
end
