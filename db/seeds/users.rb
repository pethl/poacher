puts "✨ Seeding Users..."

User.destroy_all

User.create!(
  first_name: "Lisa",
  last_name: "Pethick",
  email: "pethicklisa@gmail.com",
  password: "password",
  password_confirmation: "password"
)

puts "✅ Users seeded: #{User.count}"