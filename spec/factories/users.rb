FactoryGirl.define do
  factory :user do
    email { Forgery(:internet).email_address }
    password 'securepass'
    password_confirmation 'securepass'

    factory :admin do
      role :admin
    end

    factory :oauth_user do
      name { Forgery::Name.full_name }
      authentications { build_list :authentication, 1 }
    end
  end
end