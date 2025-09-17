# frozen_string_literal: true

FactoryBot.define do
  factory :location do
    # Use a very high base so we never collide with seed/fixture data
    sequence(:sort_order) { |n| 10_000 + n }
    sequence(:name)       { |n| "Spec Aisle #{n} Left Col #{n}" }
    active { true }

    association :created_by, factory: :user
    association :updated_by, factory: :user

    trait :inactive do
      active { false }
    end

    trait :shed do
      transient { shed_num { 1 } }
      name { "Shed #{shed_num} - Aisle 1 Right Col 1" }
    end

    trait :aisle do
      transient do
        aisle_num { 3 }
        side_val  { "Left" }
      end
      name { "Aisle #{aisle_num} #{side_val} Col 5" }
    end

    trait :column_label_alpha do
      name { "Aisle 1 Left Col B" }
    end

    trait :column_compact do
      name { "Aisle 4 Right Col3" }
    end

    trait :column_dash do
      name { "Aisle 2 Left Col-7" }
    end

    trait :trolley do
      transient { trolley_num { 2 } }
      name { "Trolley #{trolley_num} - Aisle 1 Left Col 1" }
    end
  end
end
