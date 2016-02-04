FactoryGirl.define do
  factory :membership_request, class: Company::MembershipRequest do
    company
    user
  end
end
