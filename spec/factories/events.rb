FactoryBot.define do
  factory :event do
    title { Faker::Esport.event }
    description { Faker::Lorem.paragraph }
    started_at { Faker::Date.forward }
    cover { Rack::Test::UploadedFile.new(File.join(Rails.root, "spec", "support", "files", "event_title_image.jpg")) }

    organizer
    place
  end

  trait :upcoming do
    started_at { Faker::Date.forward }
  end

  trait :past do
    started_at { Faker::Date.backward }
  end

  trait :published do
    published_at { Faker::Date.backward }
    published { true }
  end
end
