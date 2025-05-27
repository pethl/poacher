# db/seeds/staff.rb

puts "✨ Seeding Staff..."

Staff.destroy_all

staff_data = [
  { employment_status: 'Active', first_name: 'Jon', last_name: 'Collins', dept: 'Cheesemaking Team', role: 'Head Cheesemaker' },
  { employment_status: 'Active', first_name: 'Rick', last_name: 'Haywood', dept: 'Cheesemaking Team', role: 'Assistant Cheesemaker' },
  { employment_status: 'Active', first_name: 'Jason', last_name: 'Mawr', dept: 'Cheesemaking Team', role: 'Cheesemaker' },
  { employment_status: 'Active', first_name: 'Gareth', last_name: 'Gowan', dept: 'Cheesemaking Team', role: 'Cheesemaker' },
  { employment_status: 'Active', first_name: 'Jo', last_name: 'Riemer-Coulling', dept: 'Butter Team', role: 'Butter Patter' },
  { employment_status: 'Active', first_name: 'Mel', last_name: 'Wormald', dept: 'Butter Team', role: 'Butter Patter' },
  { employment_status: 'Active', first_name: 'Geraldine', last_name: 'Thien', dept: 'Butter Team', role: 'Butter Patter' },
  { employment_status: 'Active', first_name: 'Jess', last_name: 'Gladding', dept: 'Office', role: 'Office Manager' },
  { employment_status: 'Active', first_name: 'Angela', last_name: 'Rigden', dept: 'Office', role: 'Administrator' },
  { employment_status: 'Active', first_name: 'Jo', last_name: 'Day', dept: 'Office', role: 'Technical Manager' },
  { employment_status: 'Active', first_name: 'Tim', last_name: 'Jones', dept: 'Office', role: 'Owner' },
  { employment_status: 'Active', first_name: 'Simon', last_name: 'Jones', dept: 'Office', role: 'Owner' },
  { employment_status: 'Active', first_name: 'Andy', last_name: 'Hutchinson', dept: 'Cheese Store', role: 'Store Manager' },
  { employment_status: 'Active', first_name: 'Sally', last_name: 'Tagg', dept: 'Cutting Room', role: 'Cutting Room Supervisor' },
  { employment_status: 'Active', first_name: 'Stephen', last_name: 'Bailey', dept: 'Cutting Room', role: 'Cutting Room Personnel' },
  { employment_status: 'Active', first_name: 'Penny', last_name: 'Meldrum', dept: 'Cutting Room', role: 'Cutting Room Personnel' },
  { employment_status: 'Active', first_name: 'Jessica', last_name: 'Jones', dept: 'Cutting Room', role: 'Cutting Room Personnel' },
  { employment_status: 'Inactive', first_name: 'Lisa', last_name: 'Pethick', dept: 'Office', role: 'System Design & Build' }
]

staff_data.each do |attrs|
  Staff.create!(attrs)
end

puts "✅ Staff seeded: #{Staff.count}"