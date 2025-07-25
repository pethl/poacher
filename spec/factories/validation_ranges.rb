FactoryBot.define do
  factory :validation_range do
    field_name { "MyString" }
    min_value { 1.5 }
    max_value { 1.5 }
    active { false }
  end
end
