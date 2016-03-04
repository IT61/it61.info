FactoryGirl.define do
  factory :company_member, class: Company::Member do
    association :user
    association :company
    roles :employer

    factory :company_admin do
      roles :admin
    end
  end
end
