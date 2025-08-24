FactoryBot.define do
  factory :delivery_inspection do
    delivery_date { "2025-08-24" }
    item { "MyString" }
    batch_no { "MyString" }
    best_before { "2025-08-24" }
    cert_received { false }
    damage { false }
    foreign_contam { false }
    pest_contam { false }
    timely_delivery { false }
    satisfactory { false }
    comments { "MyText" }
    staff { nil }
    staff_signature { "MyString" }
  end
end
