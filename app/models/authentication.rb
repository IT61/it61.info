# frozen_string_literal: true
class Authentication < ApplicationRecord
  belongs_to :user
  validates :uid, uniqueness: { scope: :provider }
end
