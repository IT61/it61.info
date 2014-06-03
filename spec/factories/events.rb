FactoryGirl.define do
  factory :event do
    title { Forgery::LoremIpsum.title(random: true) }
    place { Forgery::Address.street_address }
    association :organizer, factory: :user
  end
end
