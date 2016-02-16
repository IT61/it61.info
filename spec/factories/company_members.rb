FactoryGirl.define do
  factory :company_member, class: Company::Member do
    company
    user

    trait :admin do
      callback(:after_build, :after_stub) { |company_member| company_member.roles << :admin }
    end
  end
end
