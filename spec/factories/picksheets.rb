FactoryBot.define do
  factory :picksheet do
    date_order_placed { Date.today }
    delivery_required_by { Date.today + 1.day }
    delivery_time_of_day { "AM" }
    contact
    user
    status { "Open" }
  end
end
