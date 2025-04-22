FactoryBot.define do
  factory :palletised_distribution do
    date { Date.today }
    company_name { "Example Logistics Ltd." }
    registration { "AB12 XYZ" }
    trailer_number_type { "Type A" }
    temperature { 4.5 }
    vehicle_clean { true }
    destination { "Main Warehouse" }
    number_of_pallets { 3 }
    staff
    staff_signature { "Signed by staff" }
    driver_signature { "Signed by driver" }
  end
end
