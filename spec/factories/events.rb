FactoryGirl.define do
  factory :event do
    title { Forgery::LoremIpsum.title(random: true) }
    place { Forgery::Address.street_address }
    description { Forgery::LoremIpsum.paragraphs }
    started_at { Forgery::Date.date }
    title_image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'files', 'event_title_image.jpg')) }

    association :organizer, factory: :user
  end

  trait :upcoming do
    started_at { Forgery::Date.date(future: true) }
  end

  trait :published do
    published_at Forgery::Basic.number.days.ago
    published true
  end
end
