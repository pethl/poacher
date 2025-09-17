FactoryBot.define do
  factory :batch_weight do
    association :makesheet
    date { Date.today }
    washed_batch_weight { 620.25 }
    total_waste { 12.5 }
    comments { "After trim" }
  end
end