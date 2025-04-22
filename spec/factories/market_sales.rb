FactoryBot.define do
  factory :market_sale do
    market { "Test Market" }
    sale_date { Date.today }
    cheese_sales { 100.0 }
    butter_sales { 50.0 }
    honey_sales { 20.0 }
    egg_sales { 35.0 }
    plum_bread { 100.0 }
    milk { 26.0 }
    other_cheese { 0.0 }
    total_sales { 25.0 }
    weight { 10.0 }
  end
end
