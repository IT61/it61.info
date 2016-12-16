FactoryGirl.define do
  factory :event do
    title { Forgery::LoremIpsum.title(random: true) }
    description { Forgery::LoremIpsum.paragraphs }
    started_at { Forgery::Date.date }
    cover { Rack::Test::UploadedFile.new(File.join(Rails.root, "spec", "support", "files", "event_title_image.jpg")) }

    organizer
    place
  end

  trait :upcoming do
    started_at { Forgery::Date.date(future: true) }
  end

  trait :past do
    started_at { Forgery::Date.date(past: true) }
  end

  trait :published do
    published_at { Forgery::Date.date(future: true) }
    published { true }
  end
end
