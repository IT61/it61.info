FactoryGirl.define do
  factory :user do
    email { Forgery(:internet).email_address }
    password 'securepass'
    password_confirmation 'securepass'

    factory :admin do
      role :admin
    end
  end
end
