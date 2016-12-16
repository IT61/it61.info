FactoryGirl.define do
  factory :group do
    name { Forgery::LoremIpsum.title(random: true) }
  end
end
