puts "✨ Seeding Reference values..."

Reference.destroy_all

reference_data = [
  # Grades
  { group: 'grade', value: 'Poacher', model: 'System Wide' },
  { group: 'grade', value: 'Vintage', model: 'System Wide' },
  { group: 'grade', value: 'Double Barrel', model: 'System Wide' },
  { group: 'grade', value: 'Knuckle Duster', model: 'System Wide' },
  { group: 'grade', value: 'Grating', model: 'System Wide' },
  { group: 'grade', value: 'Poacher Leave', model: 'System Wide' },
  { group: 'grade', value: 'Vintage Leave', model: 'System Wide' },

  # Wash Status
  { group: 'wash_status', value: 'Created', model: 'Wash' },
  { group: 'wash_status', value: 'Approved', model: 'Wash' },
  { group: 'wash_status', value: 'Completed', model: 'Wash' },

  # Turned By
  { group: 'turned_by', value: 'Florence', description: 'Method by which Cheese was turned on the racks', model: 'Turns' },
  { group: 'turned_by', value: 'Hand', description: 'Method by which Cheese was turned on the racks', model: 'Turns' },

  # Weight Types
  { group: 'weight_type', value: 'Standard (20 kgs)', description: 'Standard (20 kgs)', model: 'Calculations' },
  { group: 'weight_type', value: 'Half Truckle (10kgs)', description: 'Half Truckle (10kgs), for Red only', model: 'Calculations' },
  { group: 'weight_type', value: 'Midi (8 kgs)', description: 'Midi (8 kgs)', model: 'Calculations' },
  { group: 'weight_type', value: '2.5kg', description: '2.5kg', model: 'Calculations' },

  # Departments
  { group: 'department', value: 'Cheesemaking Team', model: 'Staff' },
  { group: 'department', value: 'Butter Team', model: 'Staff' },
  { group: 'department', value: 'Office', model: 'Staff' },
  { group: 'department', value: 'Cheese Store', model: 'Staff' },
  { group: 'department', value: 'Cutting Room', model: 'Staff' },

  # Employment Status
  { group: 'employment_status', value: 'Active', model: 'Staff' },
  { group: 'employment_status', value: 'Inactive', model: 'Staff' },

  # Pick Status
  { group: 'pick_status', value: 'Open', model: 'PickSheet' },
  { group: 'pick_status', value: 'Assigned', model: 'PickSheet' },
  { group: 'pick_status', value: 'Shipped', model: 'PickSheet' },

  # Make Types
  { group: 'make_type', value: 'Standard', model: 'MakeSheet' },
  { group: 'make_type', value: 'Red', model: 'MakeSheet' },
  { group: 'make_type', value: 'P50', model: 'MakeSheet' },

  # Traffic Lights
  { group: 'trafficlights', value: 'Green', model: 'Samples' },
  { group: 'trafficlights', value: 'Yellow', model: 'Samples' },
  { group: 'trafficlights', value: 'Red', model: 'Samples' },

  # Batch Status
  { group: 'batch_status', value: 'Created', model: 'MakeSheet' },
  { group: 'batch_status', value: 'Nursery', model: 'MakeSheet' },
  { group: 'batch_status', value: 'Store', model: 'MakeSheet' },
  { group: 'batch_status', value: 'Wash', model: 'MakeSheet' },
  { group: 'batch_status', value: 'Finished', model: 'MakeSheet' },

  # Starter Culture
  { group: 'starter_culture', value: 'RA21', model: 'MakeSheet' },
  { group: 'starter_culture', value: 'RA24', model: 'MakeSheet' },

  # Weather
  { group: 'weather', value: 'Sunny', model: 'MakeSheet' },
  { group: 'weather', value: 'Cloudy', model: 'MakeSheet' },
  { group: 'weather', value: 'Overcast', model: 'MakeSheet' },
  { group: 'weather', value: 'Fog', model: 'MakeSheet' },
  { group: 'weather', value: 'Rain (light)', model: 'MakeSheet' },
  { group: 'weather', value: 'Rain (heavy)', model: 'MakeSheet' },
  { group: 'weather', value: 'Hail', model: 'MakeSheet' },
  { group: 'weather', value: 'Snow', model: 'MakeSheet' },
  { group: 'weather', value: 'Stormy', model: 'MakeSheet' },

  # Carrier
  { group: 'carrier', value: 'DPD by 12', model: 'PalletisedDistribution' },
  { group: 'carrier', value: 'Langdons', model: 'PalletisedDistribution' },
  { group: 'carrier', value: 'Palletline', model: 'PalletisedDistribution' },
  { group: 'carrier', value: 'Tim to Deliver', model: 'PalletisedDistribution' },
  { group: 'carrier', value: 'Customer Collect', model: 'PalletisedDistribution' },

  # Grading Bore
  { group: 'grade_bore', value: 'good', model: 'GradingNote' },
  { group: 'grade_bore', value: 'with holes', model: 'GradingNote' },
  { group: 'grade_bore', value: 'smooth', model: 'GradingNote' },
  { group: 'grade_bore', value: 'grainy', model: 'GradingNote' },

  # Grading Texture
  { group: 'grade_texture', value: 'good', model: 'GradingNote' },
  { group: 'grade_texture', value: 'creamy', model: 'GradingNote' },
  { group: 'grade_texture', value: 'grainy', model: 'GradingNote' },
  { group: 'grade_texture', value: 'sticky', model: 'GradingNote' },

  # Grading Taste
  { group: 'grade_taste', value: 'mild', model: 'GradingNote' },
  { group: 'grade_taste', value: 'tangy', model: 'GradingNote' },
  { group: 'grade_taste', value: 'sharp', model: 'GradingNote' },
  { group: 'grade_taste', value: 'strong', model: 'GradingNote' },

  # Grading Appearance
  { group: 'grade_appearance', value: 'bowed', model: 'GradingNote' },
  { group: 'grade_appearance', value: 'straight', model: 'GradingNote' },
  { group: 'grade_appearance', value: 'dry', model: 'GradingNote' },
  { group: 'grade_appearance', value: 'sagged', model: 'GradingNote' }
]

Reference.create!(reference_data)

puts "✅ Reference values seeded successfully!"
