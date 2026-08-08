FactoryBot.define do
  factory :picksheet do
    date_order_placed { Date.current }
    delivery_required_by { Date.current + 1.day }
    delivery_time_of_day { "AM" }

    contact
    user

    status { "Hold" }

    trait :assigned do
      status { "Assigned" }
    end

    trait :cutting do
      status { "Cutting" }
    end

    trait :shipped do
      status { "Shipped" }
    end
  end
end