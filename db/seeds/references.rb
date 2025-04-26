puts "✨ Seeding Reference values..."

Reference.destroy_all

reference_data = [
  # Grades
  { group: 'grade', value: 'Poacher Leave', model: 'System Wide', sort_order: 1 },
  { group: 'grade', value: 'Vintage Leave', model: 'System Wide', sort_order: 2 },
  { group: 'grade', value: 'Grating', model: 'System Wide', sort_order: 3 },
  { group: 'grade', value: 'Knuckle Duster', model: 'System Wide', sort_order: 4 },
  { group: 'grade', value: 'Double Barrel', model: 'System Wide', sort_order: 5 },
  { group: 'grade', value: 'Vintage', model: 'System Wide', sort_order: 6 },
  { group: 'grade', value: 'Poacher', model: 'System Wide', sort_order: 7 },

  # Wash Status
  { group: 'wash_status', value: 'Completed', model: 'Wash', sort_order: 1 },
  { group: 'wash_status', value: 'Approved', model: 'Wash', sort_order: 2 },
  { group: 'wash_status', value: 'Created', model: 'Wash', sort_order: 3 },

  # Turned By
  { group: 'turned_by', value: 'Hand', description: 'Method by which Cheese was turned on the racks', model: 'Turns', sort_order: 1 },
  { group: 'turned_by', value: 'Florence', description: 'Method by which Cheese was turned on the racks', model: 'Turns', sort_order: 2 },

  # Weight Types
  { group: 'weight_type', value: '2.5kg', description: '2.5kg', model: 'Calculations', sort_order: 1 },
  { group: 'weight_type', value: 'Midi (8 kgs)', description: 'Midi (8 kgs)', model: 'Calculations', sort_order: 2 },
  { group: 'weight_type', value: 'Half Truckle (10kgs)', description: 'Half Truckle (10kgs), for Red only', model: 'Calculations', sort_order: 3 },
  { group: 'weight_type', value: 'Standard (20 kgs)', description: 'Standard (20 kgs)', model: 'Calculations', sort_order: 4 },

  # Departments
  { group: 'department', value: 'Cutting Room', model: 'Staff', sort_order: 1 },
  { group: 'department', value: 'Cheese Store', model: 'Staff', sort_order: 2 },
  { group: 'department', value: 'Office', model: 'Staff', sort_order: 3 },
  { group: 'department', value: 'Butter Team', model: 'Staff', sort_order: 4 },
  { group: 'department', value: 'Cheesemaking Team', model: 'Staff', sort_order: 5 },

  # Employment Status
  { group: 'employment_status', value: 'Inactive', model: 'Staff', sort_order: 1 },
  { group: 'employment_status', value: 'Active', model: 'Staff', sort_order: 2 },

  # Scale Check frequency
  { group: 'scalecheck_frequency', value: 'Weekly', model: 'ScaleCheck', sort_order: 1 },
  { group: 'scalecheck_frequency', value: 'Daily', model: 'ScaleCheck', sort_order: 2 },

  # Scale name and number
  { group: 'scale_name_serial', value: 'Individual Portion Scale Yanti MARSDEN Super SS S/No: 202306019', description: 'Individual', model: 'ScaleCheck', sort_order: 1 },
  { group: 'scale_name_serial', value: 'Individual Portion Scale Yanti Super SS S/No: 1512085', description: 'Individual', model: 'ScaleCheck', sort_order: 2 },
  { group: 'scale_name_serial', value: 'CHEESE OUT - DISPLAY E1005 (112550301) / PAN H205 (11-430113) ',  description: 'Pan', model: 'ScaleCheck', sort_order: 3 },
  { group: 'scale_name_serial', value: 'CHEESE IN - DISPLAY SALTER DP25 (003020) / PAN H205  (20-360974)', description: 'Pan', model: 'ScaleCheck', sort_order: 4 },
  { group: 'scale_name_serial', value: 'AVERY XTi101 - Serial Number: 23320104', description: 'Daily', model: 'ScaleCheck', sort_order: 5 },
  { group: 'scale_name_serial', value: 'AVERY XTi101 - Serial Number: 23320103', description: 'Daily', model: 'ScaleCheck', sort_order: 6 },
  { group: 'scale_name_serial', value: 'AVERY XTi101 - Serial Number: 23320102', description: 'Daily', model: 'ScaleCheck', sort_order: 7 },

  # Pick Status
  { group: 'pick_status', value: 'Shipped', model: 'PickSheet', sort_order: 1 },
  { group: 'pick_status', value: 'Assigned', model: 'PickSheet', sort_order: 2 },
  { group: 'pick_status', value: 'Open', model: 'PickSheet', sort_order: 3 },

  # Make Types
  { group: 'make_type', value: 'P50', model: 'MakeSheet', sort_order: 1 },
  { group: 'make_type', value: 'Red', model: 'MakeSheet', sort_order: 2 },
  { group: 'make_type', value: 'Standard', model: 'MakeSheet', sort_order: 3 },

   # Mill Types
   { group: 'makesheet_mill', value: 'Mill 1', model: 'MakeSheet', sort_order: 1 },
   { group: 'makesheet_mill', value: 'Mill 2 (spare)', model: 'MakeSheet', sort_order: 2 },

  # Traffic Lights
  { group: 'trafficlights', value: 'Red', model: 'Samples', sort_order: 1 },
  { group: 'trafficlights', value: 'Yellow', model: 'Samples', sort_order: 2 },
  { group: 'trafficlights', value: 'Green', model: 'Samples', sort_order: 3 },

  # Batch Status
  { group: 'batch_status', value: 'Finished', model: 'MakeSheet', sort_order: 1 },
  { group: 'batch_status', value: 'Wash', model: 'MakeSheet', sort_order: 2 },
  { group: 'batch_status', value: 'Store', model: 'MakeSheet', sort_order: 3 },
  { group: 'batch_status', value: 'Nursery', model: 'MakeSheet', sort_order: 4 },
  { group: 'batch_status', value: 'Created', model: 'MakeSheet', sort_order: 5 },

  # Starter Culture
  { group: 'starter_culture', value: 'RA24', model: 'MakeSheet', sort_order: 1 },
  { group: 'starter_culture', value: 'RA21', model: 'MakeSheet', sort_order: 2 },

  # Weather
  { group: 'weather', value: 'Stormy', model: 'MakeSheet', sort_order: 1 },
  { group: 'weather', value: 'Snow', model: 'MakeSheet', sort_order: 2 },
  { group: 'weather', value: 'Hail', model: 'MakeSheet', sort_order: 3 },
  { group: 'weather', value: 'Rain (heavy)', model: 'MakeSheet', sort_order: 4 },
  { group: 'weather', value: 'Rain (light)', model: 'MakeSheet', sort_order: 5 },
  { group: 'weather', value: 'Fog', model: 'MakeSheet', sort_order: 6 },
  { group: 'weather', value: 'Overcast', model: 'MakeSheet', sort_order: 7 },
  { group: 'weather', value: 'Cloudy', model: 'MakeSheet', sort_order: 8 },
  { group: 'weather', value: 'Sunny', model: 'MakeSheet', sort_order: 9 },

  # Carrier
  { group: 'carrier', value: 'Customer Collect', model: 'PalletisedDistribution', sort_order: 1 },
  { group: 'carrier', value: 'Tim to Deliver', model: 'PalletisedDistribution', sort_order: 2 },
  { group: 'carrier', value: 'Palletline', model: 'PalletisedDistribution', sort_order: 3 },
  { group: 'carrier', value: 'Langdons', model: 'PalletisedDistribution', sort_order: 4 },
  { group: 'carrier', value: 'DPD by 12', model: 'PalletisedDistribution', sort_order: 5 },

  # Grading Bore
  { group: 'grade_bore', value: 'grainy', model: 'GradingNote', sort_order: 1 },
  { group: 'grade_bore', value: 'smooth', model: 'GradingNote', sort_order: 2 },
  { group: 'grade_bore', value: 'with holes', model: 'GradingNote', sort_order: 3 },
  { group: 'grade_bore', value: 'good', model: 'GradingNote', sort_order: 4 },

  # Grading Texture
  { group: 'grade_texture', value: 'sticky', model: 'GradingNote', sort_order: 1 },
  { group: 'grade_texture', value: 'grainy', model: 'GradingNote', sort_order: 2 },
  { group: 'grade_texture', value: 'creamy', model: 'GradingNote', sort_order: 3 },
  { group: 'grade_texture', value: 'good', model: 'GradingNote', sort_order: 4 },

  # Grading Taste
  { group: 'grade_taste', value: 'strong', model: 'GradingNote', sort_order: 1 },
  { group: 'grade_taste', value: 'sharp', model: 'GradingNote', sort_order: 2 },
  { group: 'grade_taste', value: 'tangy', model: 'GradingNote', sort_order: 3 },
  { group: 'grade_taste', value: 'mild', model: 'GradingNote', sort_order: 4 },

  # Grading Appearance
  { group: 'grade_appearance', value: 'sagged', model: 'GradingNote', sort_order: 1 },
  { group: 'grade_appearance', value: 'dry', model: 'GradingNote', sort_order: 2 },
  { group: 'grade_appearance', value: 'straight', model: 'GradingNote', sort_order: 3 },
  { group: 'grade_appearance', value: 'bowed', model: 'GradingNote', sort_order: 4 }
]

Reference.create!(reference_data)

puts "✅ Reference values seeded successfully!"
