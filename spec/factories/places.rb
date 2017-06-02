FactoryGirl.define do
  factory :place do
    title { Faker::Address.street_name }
    address { Faker::Address.street_address }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end
