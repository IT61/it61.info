FactoryGirl.define do
  factory :material do
    url { Forgery::LoremIpsum.title(random: true) }
  end
end
