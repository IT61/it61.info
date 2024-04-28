FactoryBot.define do
  factory :user, aliases: [ :organizer ] do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    fresh { false }

    trait :admin do
      role { :admin }
    end

    trait :moderator do
      role { :moderator }
    end

    trait :with_reset_password_token do
      reset_password_token { Devise.friendly_token }
    end
  end
end
