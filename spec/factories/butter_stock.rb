FactoryBot.define do
  factory :butter_stock do
    sequence(:make_date) { |n| Date.today + n }

    todays_make { 10 }
    fresh_spare_for_sale { 5 }

    market_returns_salted { 2 }
    market_returns_hm2 { 1 }
    market_returns_unsalted { 0 }

    freezer_stock_salted { 4 }
    freezer_stock_hm2 { 3 }
    freezer_stock_unsalted { 2 }

    family_butter_salted { 1 }
    family_butter_hm2 { 1 }
    family_butter_unsalted { 1 }
  end
end
