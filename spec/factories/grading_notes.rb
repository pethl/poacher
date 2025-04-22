FactoryBot.define do
  factory :grading_note do
    association :makesheet
    date { Date.today }

    appearance { "Clean" }
    bore { "Consistent" }
    texture { "Firm" }
    taste { "Sharp" }
    score { 85 }
    comments { "Nice cheese." }

    head_taster { association(:staff).id }
    assistant_taster_1 { association(:staff).id }
    assistant_taster_2 { association(:staff).id }
  end
end