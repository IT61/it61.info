FactoryGirl.define do
  factory :attendee, class: User, parent: :user

  factory :events_attendee do
    attendee
    event
  end
end
