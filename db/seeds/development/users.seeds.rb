(1..10).each do
  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    bio: Faker::Lorem.paragraph,
    email: Faker::Internet.email,
  )
end
