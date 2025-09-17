FactoryBot.define do
  factory :cheese_wash_record do
    association :makesheet   # uses your realistic makesheet factory
    date_batch_started { Date.today - rand(3..7).days }

    # By default nothing washed (nil fields) — #total_washed treats nil as 0.

    trait :partial do
      number_washed_1 { rand(6..12) }
      number_washed_2 { rand(6..12) }
      number_washed_3 { rand(6..12) }
      wash_date_1     { date_batch_started }
      wash_date_2     { date_batch_started + 1.day }
      wash_date_3     { date_batch_started + 2.days }
    end

    trait :nearly_done do
      transient { cheeses_total { makesheet&.number_of_cheeses || 30 } }
      number_washed_1 { cheeses_total - 1 }  # leave 1 remaining
      wash_date_1     { date_batch_started }
    end

    trait :finished do
      transient { cheeses_total { makesheet&.number_of_cheeses || 30 } }
      # Spread washes across a few slots to look realistic
      number_washed_1 { [cheeses_total, 16].min }
      number_washed_2 { [cheeses_total - number_washed_1, 8].min }
      number_washed_3 { (cheeses_total - number_washed_1 - number_washed_2) }
      wash_date_1     { date_batch_started }
      wash_date_2     { date_batch_started + 1.day }
      wash_date_3     { date_batch_started + 2.days }
      date_batch_finished { date_batch_started + 3.days }
    end
  end
end
