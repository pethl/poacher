FactoryBot.define do
  factory :butter_make do
    sequence(:date) { |n| Date.today + n }  # Ensure uniqueness
    cream { 5 }
    make { 2 }
    stock { 3 }
  end
end
