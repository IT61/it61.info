FactoryGirl.define do
  factory :authentication do
    uid { Forgery::Basic.encrypt }
    provider { Forgery::Name.company_name }
    link { Forgery::Internet.domain_name }
  end
end