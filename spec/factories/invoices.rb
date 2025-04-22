FactoryBot.define do
  factory :invoice do
    sequence(:number) { |n| 1000 + n }
    account { "XYZ123" }
    date { Date.today }
    amount { 123.45 }
    weight { 20.5 }
  end
end