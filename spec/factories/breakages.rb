FactoryBot.define do
  factory :breakage do
    sequence(:date) { |n| Date.current + n.days }
    association :user
  end
end