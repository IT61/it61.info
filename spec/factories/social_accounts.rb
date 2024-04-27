FactoryBot.define do
  factory :social_account do
    uid { "12345" }
    provider { "vkontakte" }

    trait :github do
      provider { "github" }
    end
  end
end
