puts "✨ Seeding Picksheets..."

Picksheet.destroy_all

user = User.find_by(email: "seed@example.com") || User.first
unless user
  puts "❌ No user found for Picksheets — skipping."
  return
end

contacts = Contact.limit(6).to_a

picksheet_data = [
  { date_order_placed: '08/11/2024', delivery_required_by: '24/11/2024', order_number: 'PD123455', contact_telephone_number: '07803 293 552', invoice_number: '6674876', carrier: 'DPD', carrier_delivery_date: '03/07/2024', number_of_boxes: 2 },
  { date_order_placed: '09/11/2024', delivery_required_by: '24/11/2024', order_number: 'PD123456', contact_telephone_number: '07803 293 553', invoice_number: '6674877', carrier: 'DPD', carrier_delivery_date: '04/07/2024', number_of_boxes: 3 },
  { date_order_placed: '10/11/2024', delivery_required_by: '14/11/2024', order_number: 'PD123457', contact_telephone_number: '07803 293 554', invoice_number: '6674878', carrier: 'BY HAND', carrier_delivery_date: '05/07/2024', number_of_boxes: 1 }
]

picksheet_data.each_with_index do |attrs, i|
  Picksheet.create!(
    **attrs,
    contact_id: contacts[i % contacts.size].id,
    user_id: user.id
  )
end

puts "✅ Picksheets seeded: #{Picksheet.count}"

