FactoryGirl.define do
  factory :membership_request, class: Company::MembershipRequest do
    association :user
    association :company
  end
end
