FactoryGirl.define do
  factory :membership_request do
    association :user
    association :company
  end
end
