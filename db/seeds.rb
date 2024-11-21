# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data to avoid duplication
User.destroy_all
Follow.destroy_all
SleepRecord.destroy_all

# Create Users
users = []
10.times do |_i|
  users << User.create!(
    name: Faker::Name.unique.name
  )
end

puts "Created #{User.count} users."

# Create Follows
users.each_with_index do |user, _index|
  # Each user follows 2 random users (except themselves)
  followed_users = users.sample(2).reject { |u| u == user }
  followed_users.each do |followed|
    Follow.create!(
      follower: user,
      followed: followed
    )
  end
end

puts "Created #{Follow.count} follow relationships."

# Create Sleep Records
users.each do |user|
  5.times do
    clock_in = Faker::Time.backward(days: 7, period: :evening) # Random time in the past week
    clock_out = clock_in + rand(6..10).hours # Random sleep duration between 6 to 10 hours
    SleepRecord.create!(
      user: user,
      clock_in: clock_in,
      clock_out: clock_out
    )
  end
end

puts "Created #{SleepRecord.count} sleep records."
