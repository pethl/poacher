FactoryBot.define do
  factory :makesheet do
    sequence(:make_date) { |n| Date.today + n.days }
    make_type { "Standard" }
    status { "Created" }
    batch { "B123" }
   # grade { "Poacher" }

    trait :with_I do
     
      milk_used { 6090 }
      salt_weight_net { 12.33 }
      type_of_starter_culture_used { "RA13" }
      qty_of_starter_used { 1.23 }
    end

    trait :with_II do

      first_cut_time { Time.current }
      second_cut_time { Time.current + 1.hour }
      third_cut_time { Time.current + 2.hours }
      fourth_cut_time { Time.current + 3.hours }
    end

    trait :with_III do
      
      total_weight { 40.0 }
      number_of_cheeses { 20 }
    end

    trait :with_IV do
      association :pre_start_inspection_by_staff, factory: :staff
    end

  end
end