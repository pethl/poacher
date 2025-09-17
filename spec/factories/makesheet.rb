# spec/factories/makesheets.rb
FactoryBot.define do
  factory :makesheet do
    # Keep uniqueness easy; by default these will be future dates, which is fine for most tests.
    sequence(:make_date) { |n| Date.today + n.days }
    make_type { "Standard" }
    status    { "Created" }
    batch     { "B123" }

    # Core realistic defaults so a bare makesheet is valid for most specs
    milk_used          { rand(5500..6200) }             # L
    number_of_cheeses  { rand(28..32) }                 # count
    total_weight       { number_of_cheeses * 20 }       # kg (~20kg each)
    type_of_starter_culture_used { "RA13" }
    qty_of_starter_used { 10.0 }                        # ≥ 10 to satisfy ranges
    salt_weight_net    { 12.0 } 
    # If anything changes cheese count after build, keep total_weight in sync.
    after(:build) do |m|
      m.total_weight ||= m.number_of_cheeses.to_i * 20
    end

    # --- Your staged traits, now realistic ---

    trait :with_I do
      # stage I: type + milk + starter details
      milk_used                   { rand(5500..6200) }
      salt_weight_net             { 12.0 }
      type_of_starter_culture_used { "RA13" }
      qty_of_starter_used         { 10.0 }             # keep at/above min
    end

    trait :with_II do
      first_cut_time  { Time.current.change(sec: 0) }
      second_cut_time { first_cut_time + 30.minutes }
      third_cut_time  { second_cut_time + 30.minutes }
      fourth_cut_time { third_cut_time + 30.minutes }
    end

    trait :with_III do
      number_of_cheeses { 30 }
      total_weight      { 600 }                        # 30 × 20kg
    end

    trait :with_IV do
      association :pre_start_inspection_by_staff, factory: :staff
    end

    # Handy extra traits you might find useful
    trait :yesterday do
      make_date { Date.yesterday }
    end

    trait :recent do
      # newest possible < today, useful for “recent” windows
      make_date { Time.zone.now.beginning_of_day - rand(0..3600).seconds }
    end
  end
end
