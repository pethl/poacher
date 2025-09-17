FactoryBot.define do
  factory :validation_range do
    target_model { "Makesheet" }
    field_name   { "milk_used" }
    min_value    { 4000 }
    max_value    { 8000 }
    active       { true }

    association :created_by, factory: :user
    association :updated_by, factory: :user
  end
end

