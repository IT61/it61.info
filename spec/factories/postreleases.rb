FactoryGirl.define do
  factory :postrelease do
    body { Forgery::LoremIpsum.paragraphs }
  end
end
