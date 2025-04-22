# spec/factories/washes.rb
FactoryBot.define do
  factory :wash do
    action_date { Date.today }
  end
end