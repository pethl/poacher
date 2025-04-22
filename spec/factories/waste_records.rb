FactoryBot.define do
  factory :waste_record do
    association :traceability_record
    waste_date { Date.today }
    wedges { 1.0 }
    cooking { 2.0 }
    blue { 1.0 }
    t_and_bs { 0.5 }
    waste { 1.0 }
  end
end