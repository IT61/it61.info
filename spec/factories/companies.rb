FactoryGirl.define do
  factory :company do
    name { Forgery::LoremIpsum.title(random: true) }
  end
end
