FactoryBot.define do
  factory :picksheet_item do
    picksheet
    product { "Poacher" }
    size { "1/3" }
    count { 5 }
    weight { 10.5 }
    sp_price { 20.0 }
  end
end
