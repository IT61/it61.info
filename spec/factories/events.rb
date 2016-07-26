# frozen_string_literal: true
FactoryGirl.define do
  factory :event do
    sequence(:title) { |n| "Tech meetup ##{n}" }
    description "Some meetup at some place. Will be cool!"
    started_at Time.now
  end
end
