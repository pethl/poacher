FactoryBot.define do
  factory :turn do
    association :makesheet
    turn_date { Date.current }
    turn_method { "Manual" }
    association :turned_by, factory: :user
  end
end