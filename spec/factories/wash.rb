# spec/factories/washes.rb
FactoryBot.define do
  factory :wash do
    action_date { Date.today }
    wash_status { 'Created' }
  end
end