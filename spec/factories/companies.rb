FactoryGirl.define do
  factory :company do
    title { Forgery::LoremIpsum.title(random: true) }
    description { Forgery::LoremIpsum.paragraphs }
    contacts { Forgery::Date.date }

    association :founder, factory: :user

    trait :published do
      published true
    end
  end

end
