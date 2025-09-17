FactoryBot.define do
  factory :ingredient_batch_change do
    association :makesheet
    association :delivery_inspection

    # keep this in sync with the delivery_inspection.item
    item       { delivery_inspection&.item || 'Rennet - Vegetable' }
    changed_on { Date.today }
    notes      { 'Supplier change' }
  end
end

