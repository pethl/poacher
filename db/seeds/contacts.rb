# db/seeds/contacts.rb

puts "✨ Seeding Contacts..."

Contact.destroy_all

require 'faker'

contact_names = [
  "ALBION FF", "ALL GOOD MARKET", "BACI AND CO", "BARKERS BUTCHERS",
  "BARSBY", "BEAUMONTS", "BEAUMONTS DELI", "BEDFORD CHEESE CO",
  "BELLS TEA ROOM", "BENNETTS BUTCHERS", "BENTLEYS", "BIG WHEEL CHEESE",
  "BIUCHANANS", "BLUE SKY HALLOUMI", "BOOTH HOUSE FARMSHOP",
  "BRISTOL CHEESEMONGER", "BRODIE AND FLYNN", "BUCHANANS", "CAMBRIDGE CHEESE CO",
  "CANNELLS"
]

contact_names.each_with_index do |name, index|
  payment_option = if rand < 0.10
    { pre_payment: false, payment_on_receipt: true }
  elsif rand < 0.20
    { pre_payment: true, payment_on_receipt: false }
  else
    { pre_payment: false, payment_on_receipt: false }
  end

  Contact.create!(
    business_name: name,
    contact_name: Faker::Name.name,
    reference: "REF#{index + 1000}",
    email: Faker::Internet.email(name: name),
    mobile: Faker::PhoneNumber.cell_phone_in_e164,
    phone: Faker::PhoneNumber.phone_number,
    country: "UK",
    address: Faker::Address.full_address,
    terms_and_conditions: "Standard terms apply.",
    sage_delivery_note: true,
    notes: Faker::Company.bs,
    **payment_option
  )
end

puts "✅ Contacts seeded: #{Contact.count}"


