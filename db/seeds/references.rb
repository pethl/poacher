# db/seeds/references.rb

puts "✨ Seeding Reference values..."

Reference.destroy_all

reference_data = [
  # Grades
  { group: 'grade', value: 'Poacher' },
  { group: 'grade', value: 'Vintage' },
  { group: 'grade', value: 'Double Barrel' },
  { group: 'grade', value: 'Knuckle Duster' },
  { group: 'grade', value: 'Grating' },
  { group: 'grade', value: 'Poacher Leave' },
  { group: 'grade', value: 'Vintage Leave' },

  # Wash Status
  { group: 'wash_status', value: 'Created' },
  { group: 'wash_status', value: 'Approved' },
  { group: 'wash_status', value: 'Completed' },

  # Turned By
  { group: 'turned_by', value: 'Florence', description: 'Method by which Cheese was turned on the racks' },
  { group: 'turned_by', value: 'Hand', description: 'Method by which Cheese was turned on the racks' },

  # Weight Types
  { group: 'weight_type', value: 'Standard (20 kgs)', description: 'Standard (20 kgs)' },
  { group: 'weight_type', value: 'Half Truckle (10kgs)', description: 'Half Truckle (10kgs), for Red only' },
  { group: 'weight_type', value: 'Midi (8 kgs)', description: 'Midi (8 kgs)' },
  { group: 'weight_type', value: '2.5kg', description: '2.5kg' },

  # Departments
  { group: 'department', value: 'Cheesemaking Team' },
  { group: 'department', value: 'Butter Team' },
  { group: 'department', value: 'Office' },
  { group: 'department', value: 'Cheese Store' },
  { group: 'department', value: 'Cutting Room' },

  # Employment Status
  { group: 'employment_status', value: 'Active' },
  { group: 'employment_status', value: 'Inactive' },

  # Pick Status
  { group: 'pick_status', value: 'Open' },
  { group: 'pick_status', value: 'Assigned' },
  { group: 'pick_status', value: 'Shipped' },

  # Make Types
  { group: 'make_type', value: 'Standard' },
  { group: 'make_type', value: 'Red' },
  { group: 'make_type', value: 'P50' },

  # Traffic Lights
  { group: 'trafficlights', value: 'Green' },
  { group: 'trafficlights', value: 'Yellow' },
  { group: 'trafficlights', value: 'Red' },

  # Batch Status
  { group: 'batch_status', value: 'Created' },
  { group: 'batch_status', value: 'Nursery' },
  { group: 'batch_status', value: 'Store' },
  { group: 'batch_status', value: 'Wash' },
  { group: 'batch_status', value: 'Finished' },

  # Starter Culture
  { group: 'starter_culture', value: 'RA21' },
  { group: 'starter_culture', value: 'RA24' },

  # Weather
  { group: 'weather', value: 'Sunny' },
  { group: 'weather', value: 'Cloudy' },
  { group: 'weather', value: 'Overcast' },
  { group: 'weather', value: 'Fog' },
  { group: 'weather', value: 'Rain (light)' },
  { group: 'weather', value: 'Rain (heavy)' },
  { group: 'weather', value: 'Hail' },
  { group: 'weather', value: 'Snow' },
  { group: 'weather', value: 'Stormy' },

  # Carrier
  { group: 'carrier', value: 'DPD by 12' },
  { group: 'carrier', value: 'Langdons' },
  { group: 'carrier', value: 'Palletline' },
  { group: 'carrier', value: 'Tim to Deliver' },
  { group: 'carrier', value: 'Customer Collect' }
]

reference_data.each do |attrs|
  Reference.create!(attrs)
end

puts "✅ References seeded: #{Reference.count}"