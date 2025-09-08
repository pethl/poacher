FactoryBot.define do
  factory :ingredient_batch_change do
    makesheet { nil }
    delivery_inspection { nil }
    item { "MyString" }
    changed_on { "2025-08-24" }
    notes { "MyText" }
  end
end
