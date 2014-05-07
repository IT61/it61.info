FactoryGirl.define do
  factory :event do
    title { Forgery::LoremIpsum.title(random: true) }
  end
end
