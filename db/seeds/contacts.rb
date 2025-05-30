# db/seeds/contacts.rb

puts "✨ Seeding Contacts..."

Contact.destroy_all

require 'csv'

csv_path = Rails.root.join('db', 'seeds', 'good_customers_from_sage_may.csv')

CSV.foreach(csv_path, headers: true) do |row|
  Contact.create!(
    reference: row['Reference'],
    business_name: row['business_name'],
    address: row['address'],
    contact_name: row['contact_name'],
    phone: row['phone'],
    mobile: row['mobile'],
    email: row['email'],
    days_after_invoice: row['days_after_invoice'].to_i
  )
end