FactoryBot.define do
  factory :scale_check do
    frequency { "MyString" }
    check_date { "2025-04-25" }
    scale_name { "MyString" }
    scale_100g { false }
    scale_500g { false }
    scale_1kg { false }
    scale_5kg { false }
    scale_10kg { false }
    comments { "MyString" }
    signature { "MyText" }
    staff { nil }
  end
end
