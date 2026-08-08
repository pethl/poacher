FactoryBot.define do
  factory :picksheet_item do
    association :picksheet

    product { "Poacher" }
    size { "1/3" }
    pricing { "Standard" }
    count { 5 }

    weight { 10.5 }
    sp_price { 20.0 }

    trait :butter do
      product { "Salted Butter" }
      size { "250g" }
    end

    trait :guest_cheese do
      makesheet
      product { nil }
      size { nil }
    end

    trait :custom_note do
      count { nil }
      custom_notes { "Cut to customer specification" }
    end
  end
end
