FactoryBot.define do
  factory :user do
    first_name { "Testy" }
    last_name { "McUser" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    role { 0 }
    admin { false }
    account_active { true }
  end
end