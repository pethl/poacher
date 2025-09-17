FactoryBot.define do
  factory :delivery_inspection do
    # associations
    association :staff   # assumes you already have a :staff factory

    # realistic defaults (you can override these in specs)
    delivery_date    { Date.today }
    item             { "Rennet - Animal" }
    batch_no         { "BATCH#{rand(100..999)}" }
    best_before      { Date.today + 6.months }

    cert_received    { true }
    damage           { false }
    foreign_contam   { false }
    pest_contam      { false }
    satisfactory     { true }

    staff_signature  { "J.Doe" }

    trait :damaged do
      damage       { true }
      satisfactory { false }
    end

    trait :foreign_contam do
      foreign_contam { true }
      satisfactory   { false }
    end

    trait :expired do
      best_before { Date.yesterday }
    end
  end
end

