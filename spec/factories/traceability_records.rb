FactoryBot.define do
  factory :traceability_record do
    association :makesheet
    date_started_batch { Date.today }

    individual_cheese_weight_1 { 1.0 }
    individual_cheese_weight_2 { 2.0 }
    # others nil by default
  end
end