FactoryBot.define do
  factory :turn do
    turn_date { Date.today }
    association :makesheet
  end
end