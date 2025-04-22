FactoryBot.define do
  factory :contact do
    sequence(:business_name) { |n| "Business #{n}" }
    contact_name { "Jane Smith" }
    email { "jane@example.com" }
    country { "UK" }
    address { "1 Cheese Lane" }

    pre_payment { false }
    payment_on_receipt { false }
    days_after_invoice { nil }
  end
end
