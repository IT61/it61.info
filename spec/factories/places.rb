FactoryBot.define do
  factory :place do
    title { Forgery::LoremIpsum.title(random: true) }
    address { Forgery::Address.street_address }
    latitude { Forgery::Geo.latitude }
    longitude { Forgery::Geo.longitude }
  end
end
