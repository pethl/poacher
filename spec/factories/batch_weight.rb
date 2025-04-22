FactoryBot.define do
  factory :batch_weight do
    date { Date.today }
    association :makesheet
  end
end