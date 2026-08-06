FactoryBot.define do
  factory :grading_note do
    association :makesheet
    association :head_taster, factory: :user

    date { Date.current }

    appearance { "Clean" }
    bore { "Consistent" }
    texture { "Firm" }
    taste { "Sharp" }
    score { 85 }
    comments { "Nice cheese." }

    taster_1_name { "Guest Taster One" }
    taster_2_name { "Guest Taster Two" }
  end
end