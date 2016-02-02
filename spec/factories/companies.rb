FactoryGirl.define do
  factory :company do
    title { Forgery(:name).company_name }

    association :founder, factory: :user
  end
end
