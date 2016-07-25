# frozen_string_literal: true
FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
end

FactoryGirl.define do
  factory :user do
    email
    first_name "Maxine"
    last_name "Caulfield"
    phone "+7 444 444 44 44"
  end
end
