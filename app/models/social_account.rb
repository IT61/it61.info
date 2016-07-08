# frozen_string_literal: true
class SocialAccount < ActiveRecord::Base
  belongs_to :user
end
