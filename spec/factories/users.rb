FactoryGirl.define do
  factory :user, aliases: [:organizer] do
    email { Forgery(:internet).email_address }
    first_name { Forgery(:name).first_name }
    last_name { Forgery(:name).last_name }

    trait :admin do
      role :admin
    end

    trait :moderator do
      role :moderator
    end

    trait :oauth_user do
      name { Forgery::Name.full_name }
      authentications { build_list :authentication, 1 }
    end

    trait :with_reset_password_token do
      reset_password_token { Sorcery::Model::TemporaryToken.generate_random_token }
    end
  end
end
