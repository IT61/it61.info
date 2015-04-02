FactoryGirl.define do
  factory :event do
    title { Forgery::LoremIpsum.title(random: true) }
    place { Forgery::Address.street_address }
    association :organizer, factory: :user
  end

  trait :upcoming do
    ignore do
      days_left { Forgery::Basic.number.days.since }
    end
    started_at { days_left }
  end

  trait :published do
    published_at Forgery::Basic.number.days.ago
    published true
  end
end
