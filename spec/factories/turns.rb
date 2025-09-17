FactoryBot.define do
  factory :turn do
    association :makesheet
    turn_date { Time.current }
    turned_by { "JD" }
  end
end