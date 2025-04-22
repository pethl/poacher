FactoryBot.define do
  factory :makesheet do
    sequence(:make_date) { |n| Date.today + n.days }
    make_type { "Standard" }
    status { "Created" }
    milk_used { 100 }
    total_weight { 401.5 }
    number_of_cheeses { 20 }
    weight_type { "Standard (20 kgs)" }
    batch { "B123" }
    grade { "Poacher" }

  end
end