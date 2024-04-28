after "development:places" do
  (1..5).each do
    # Unpublished events
    Event.create!(
      title: Faker::Esport.event,
      description: Faker::Markdown.sandwich(sentences: 6, repeat: 3),
      organizer: User.order("RANDOM()").first,
      started_at: Faker::Time.forward(days: 30),
      published: false,
      place: Place.order("RANDOM()").first
    )

    # Upcoming events
    Event.create!(
      title: Faker::Esport.event,
      description: Faker::Markdown.sandwich(sentences: 6, repeat: 3),
      organizer: User.order("RANDOM()").first,
      started_at: Faker::Time.forward(days: 30),
      published: true,
      published_at: Date.current,
            place: Place.order("RANDOM()").first

    )

    # Past events
    Event.create!(
      title: Faker::Esport.event,
      description: Faker::Markdown.sandwich(sentences: 6, repeat: 3),
      organizer: User.order("RANDOM()").first,
      started_at: Faker::Time.backward(days: 30),
      published: true,
      published_at: Faker::Time.backward(days: 10),
      place: Place.order("RANDOM()").first
    )
  end
end
