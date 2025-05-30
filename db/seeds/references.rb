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
  { group: 'weight_type', value: 'Half Truckle (10 kgs)', description: 'Half Truckle (10kgs), for Red only', model: 'Calculations', sort_order: 3 },
  { group: 'weight_type', value: 'Standard (20 kgs)', description: 'Standard (20 kgs)', model: 'Calculations', sort_order: 4 },

  #Bucket - 
  { group: 'bucket_weight', value: '1.6', description: 'Standard Dairy Bucket', model: 'Makesheet', sort_order: 1 },

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
  { group: 'pick_status', value: 'Shipped', model: 'PickSheet', sort_order: 4 },
  { group: 'pick_status', value: 'Cutting', model: 'PickSheet', sort_order: 3 },
  { group: 'pick_status', value: 'Assigned', model: 'PickSheet', sort_order: 2 },
  { group: 'pick_status', value: 'Open', model: 'PickSheet', sort_order: 1 },

  # Make Types
  { group: 'make_type', value: 'P50', model: 'MakeSheet', sort_order: 1 },
  { group: 'make_type', value: 'Red', model: 'MakeSheet', sort_order: 2 },
  { group: 'make_type', value: 'Standard', model: 'MakeSheet', sort_order: 3 },

  # Mill Types
  { group: 'makesheet_mill', value: 'Chip Mill - 1', model: 'MakeSheet', sort_order: 1 },
  { group: 'makesheet_mill', value: 'Chip Mill - spare', model: 'MakeSheet', sort_order: 2 },
  { group: 'makesheet_mill', value: 'Peg Mill', model: 'MakeSheet', sort_order: 3 },


  # Sale Pricing
  { group: 'sale_pricing', value: 'Priced', model: 'PickSheet', sort_order: 1 },
  { group: 'sale_pricing', value: 'Unpriced', model: 'PickSheet', sort_order: 2 },
  { group: 'sale_pricing', value: 'Retail', model: 'PickSheet', sort_order: 3 },
  { group: 'sale_pricing', value: 'Wholesale', model: 'PickSheet', sort_order: 3 },


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
  { group: 'grade_appearance', value: 'bowed', model: 'GradingNote', sort_order: 4 },

  # Sale Products for PickSheets

  { group: 'sale_product', value: 'Grated', model: 'PickSheet', sort_order: 1 },
  { group: 'sale_product', value: 'Poacher', model: 'PickSheet', sort_order: 2 },
  { group: 'sale_product', value: 'Vintage', model: 'PickSheet', sort_order: 3 },
  { group: 'sale_product', value: 'P50', model: 'PickSheet', sort_order: 4 },
  { group: 'sale_product', value: 'Knuckle Duster', model: 'PickSheet', sort_order: 5 },
  { group: 'sale_product', value: 'Double Barrel', model: 'PickSheet', sort_order: 6 },
  { group: 'sale_product', value: 'Red', model: 'PickSheet', sort_order: 7 },
  { group: 'sale_product', value: 'Smoked', model: 'PickSheet', sort_order: 8 },

  
    { group: 'sale_product_other', value: 'Baron Bigod - Baby', model: 'PickSheet', sort_order: 1 },
    { group: 'sale_product_other', value: 'Buffalicious', model: 'PickSheet', sort_order: 2 },
    { group: 'sale_product_other', value: 'Chabis', model: 'PickSheet', sort_order: 3 },
    { group: 'sale_product_other', value: 'Cote Hill Baby', model: 'PickSheet', sort_order: 4 },
    { group: 'sale_product_other', value: 'Dorstone', model: 'PickSheet', sort_order: 5 },
    { group: 'sale_product_other', value: 'Fetish', model: 'PickSheet', sort_order: 6 },
    { group: 'sale_product_other', value: 'Finn', model: 'PickSheet', sort_order: 7 },
    { group: 'sale_product_other', value: 'Flower Marie', model: 'PickSheet', sort_order: 8 },
    { group: 'sale_product_other', value: 'Golden Cross', model: 'PickSheet', sort_order: 9 },
    { group: 'sale_product_other', value: 'Eve', model: 'PickSheet', sort_order: 10 },
    { group: 'sale_product_other', value: 'Halloumi (Somerset)', model: 'PickSheet', sort_order: 11 },
    { group: 'sale_product_other', value: 'Katherine', model: 'PickSheet', sort_order: 12 },
    { group: 'sale_product_other', value: 'Little Lily', model: 'PickSheet', sort_order: 13 },
    { group: 'sale_product_other', value: 'Little She', model: 'PickSheet', sort_order: 14 },
    { group: 'sale_product_other', value: "Michael's Mount", model: 'PickSheet', sort_order: 15 },
    { group: 'sale_product_other', value: 'Perroche', model: 'PickSheet', sort_order: 16 },
    { group: 'sale_product_other', value: 'Ragstone', model: 'PickSheet', sort_order: 17 },
    { group: 'sale_product_other', value: 'Snowdrop', model: 'PickSheet', sort_order: 18 },
    { group: 'sale_product_other', value: 'St. Jude', model: 'PickSheet', sort_order: 19 },
    { group: 'sale_product_other', value: 'Stilton Half – Baby', model: 'PickSheet', sort_order: 20 },
    { group: 'sale_product_other', value: 'Stilton Whole - Baby', model: 'PickSheet', sort_order: 21 },
    { group: 'sale_product_other', value: 'Tor', model: 'PickSheet', sort_order: 22 },
    { group: 'sale_product_other', value: 'Wigmore – Baby', model: 'PickSheet', sort_order: 23 },


  { group: 'sale_product_butter', value: 'Salted', model: 'PickSheet', sort_order: 1 },
  { group: 'sale_product_butter', value: 'HM 2%', model: 'PickSheet', sort_order: 2 },
  { group: 'sale_product_butter', value: 'HM 3%', model: 'PickSheet', sort_order: 3 },
  { group: 'sale_product_butter', value: 'HM 4%', model: 'PickSheet', sort_order: 4 },
  { group: 'sale_product_butter', value: 'Unsalted', model: 'PickSheet', sort_order: 5 },

  { group: 'cut_guest_cheeses', value: 'Colston', model: 'PickSheet', sort_order: 1 },
  { group: 'cut_guest_cheeses', value: 'Cote Hill', model: 'PickSheet', sort_order: 2 },
  { group: 'cut_guest_cheeses', value: 'Cropwell Bishop', model: 'PickSheet', sort_order: 3 },
  { group: 'cut_guest_cheeses', value: 'Gorwydd Caerphilly', model: 'PickSheet', sort_order: 4 },
  { group: 'cut_guest_cheeses', value: 'Wyfe of Bath', model: 'PickSheet', sort_order: 5 },
  { group: 'cut_guest_cheeses', value: 'Shropshire Blue', model: 'PickSheet', sort_order: 6 },
  { group: 'cut_guest_cheeses', value: 'Stichelton', model: 'PickSheet', sort_order: 7 },
  { group: 'cut_guest_cheeses', value: 'Yarg', model: 'PickSheet', sort_order: 8 },

  { group: 'cheese_accompaniments', value: 'Plum Bread', model: 'PickSheet', sort_order: 1 },
  { group: 'cheese_accompaniments', value: 'Stockans', model: 'PickSheet', sort_order: 2 },
  { group: 'cheese_accompaniments', value: 'Damsel Millers Waffers', model: 'PickSheet', sort_order: 3 },
  { group: 'cheese_accompaniments', value: 'Old Yorkshire Chutney', model: 'PickSheet', sort_order: 4 },
  { group: 'cheese_accompaniments', value: 'Tracklements Chutney', model: 'PickSheet', sort_order: 5 },

  # Sale Sizes for PickSheets

  { group: 'sale_size', value: 'Whole', model: 'PickSheet', sort_order: 1 },
  { group: 'sale_size', value: '1/2', model: 'PickSheet', sort_order: 2 },
  { group: 'sale_size', value: '1/3 ring', model: 'PickSheet', sort_order: 3 },
  { group: 'sale_size', value: '1/4', model: 'PickSheet', sort_order: 4 },
  { group: 'sale_size', value: '1/8', model: 'PickSheet', sort_order: 5 },
  { group: 'sale_size', value: '1/16', model: 'PickSheet', sort_order: 6 },
  

   # Wedge sizes
   { group: 'wedges_sizes', value: '10 x 200g', model: 'PickSheet', sort_order: 1 },
   { group: 'wedges_sizes', value: '100g', model: 'PickSheet', sort_order: 2 },
   { group: 'wedges_sizes', value: '150-175g min', model: 'PickSheet', sort_order: 3 },
   { group: 'wedges_sizes', value: '170-200g min', model: 'PickSheet', sort_order: 4 },
   { group: 'wedges_sizes', value: '180-250g min', model: 'PickSheet', sort_order: 5 },
   { group: 'wedges_sizes', value: '200g', model: 'PickSheet', sort_order: 6 },
   { group: 'wedges_sizes', value: '200g min', model: 'PickSheet', sort_order: 7 },
   { group: 'wedges_sizes', value: '200g approx', model: 'PickSheet', sort_order: 8 },
   { group: 'wedges_sizes', value: '200g-230g min', model: 'PickSheet', sort_order: 9 },
   { group: 'wedges_sizes', value: '200g-250g min', model: 'PickSheet', sort_order: 10 },
   { group: 'wedges_sizes', value: '200g-400g min', model: 'PickSheet', sort_order: 11 },
   { group: 'wedges_sizes', value: '225g-275g min', model: 'PickSheet', sort_order: 12 },
   { group: 'wedges_sizes', value: '250g', model: 'PickSheet', sort_order: 12 },
   { group: 'wedges_sizes', value: '250g-350g', model: 'PickSheet', sort_order: 14 },
   { group: 'wedges_sizes', value: '300g', model: 'PickSheet', sort_order: 15 },
   { group: 'wedges_sizes', value: '400-450g min', model: 'PickSheet', sort_order: 16 },
   { group: 'wedges_sizes', value: '500g', model: 'PickSheet', sort_order: 17 },
   { group: 'wedges_sizes', value: '750g', model: 'PickSheet', sort_order: 18 },

  #picking sheet vac puches
 
  { group: 'vacuum_pouches', value: '160x300 Parchment', model: 'GradingNote', sort_order: 1, description: '10' },
  { group: 'vacuum_pouches', value: '200x250 Parchment', model: 'GradingNote', sort_order: 2, description: '10' },
  { group: 'vacuum_pouches', value: '250x300 Parchment', model: 'GradingNote', sort_order: 3, description: '15' },
  { group: 'vacuum_pouches', value: '250x300 Clear', model: 'GradingNote', sort_order: 4, description: '15' },
  { group: 'vacuum_pouches', value: '300x350 Clear', model: 'GradingNote', sort_order: 5, description: '15' },
  { group: 'vacuum_pouches', value: '340x450 Clear', model: 'GradingNote', sort_order: 6, description: '20' },
  { group: 'vacuum_pouches', value: '360x520 Clear', model: 'GradingNote', sort_order: 7, description: '20' },
  { group: 'vacuum_pouches', value: '530x650 Clear', model: 'GradingNote', sort_order: 8, description: '20' },

  { group: 'farmers_markets', value: 'Alford', model: 'GradingNote', sort_order: 1, description: '' },
  { group: 'farmers_markets', value: 'Bailgate', model: 'GradingNote', sort_order: 2, description: '' },
  { group: 'farmers_markets', value: 'Brigg', model: 'GradingNote', sort_order: 3, description: '' },
  { group: 'farmers_markets', value: 'Burghley', model: 'GradingNote', sort_order: 4, description: '' },
  { group: 'farmers_markets', value: 'Ealing', model: 'GradingNote', sort_order: 5, description: '' },
  { group: 'farmers_markets', value: 'Ely', model: 'GradingNote', sort_order: 6, description: '' },
  { group: 'farmers_markets', value: 'Grantham', model: 'GradingNote', sort_order: 7, description: '' },
  { group: 'farmers_markets', value: 'Harpenden', model: 'GradingNote', sort_order: 8, description: '' },
  { group: 'farmers_markets', value: 'Headingley', model: 'GradingNote', sort_order: 9, description: '' },
  { group: 'farmers_markets', value: 'Lincolnshire Show', model: 'GradingNote', sort_order: 10, description: '' },
  { group: 'farmers_markets', value: 'Market', model: 'GradingNote', sort_order: 11, description: '' },
  { group: 'farmers_markets', value: 'Market Harborough', model: 'GradingNote', sort_order: 12, description: '' },
  { group: 'farmers_markets', value: 'Marylebone', model: 'GradingNote', sort_order: 13, description: '' },
  { group: 'farmers_markets', value: 'Melton Cheese Fair', model: 'GradingNote', sort_order: 14, description: '' },
  { group: 'farmers_markets', value: 'Nether Edge', model: 'GradingNote', sort_order: 15, description: '' },
  { group: 'farmers_markets', value: 'Notting Hill', model: 'GradingNote', sort_order: 16, description: '' },
  { group: 'farmers_markets', value: 'Oakham', model: 'GradingNote', sort_order: 17, description: '' },
  { group: 'farmers_markets', value: 'Oakwood', model: 'GradingNote', sort_order: 18, description: '' },
  { group: 'farmers_markets', value: 'Oundle', model: 'GradingNote', sort_order: 19, description: '' },
  { group: 'farmers_markets', value: 'Oundle FF', model: 'GradingNote', sort_order: 20, description: '' },
  { group: 'farmers_markets', value: 'Pimlico', model: 'GradingNote', sort_order: 21, description: '' },
  { group: 'farmers_markets', value: 'Queens Park', model: 'GradingNote', sort_order: 22, description: '' },
  { group: 'farmers_markets', value: 'Retford', model: 'GradingNote', sort_order: 23, description: '' },
  { group: 'farmers_markets', value: 'Ruddington', model: 'GradingNote', sort_order: 24, description: '' },
  { group: 'farmers_markets', value: 'Sharrow Vale', model: 'GradingNote', sort_order: 25, description: '' },
  { group: 'farmers_markets', value: 'Sleaford', model: 'GradingNote', sort_order: 26, description: '' },
  { group: 'farmers_markets', value: 'Spalding', model: 'GradingNote', sort_order: 27, description: '' },
  { group: 'farmers_markets', value: 'St Albans', model: 'GradingNote', sort_order: 28, description: '' },
  { group: 'farmers_markets', value: 'St Ives', model: 'GradingNote', sort_order: 29, description: '' },
  { group: 'farmers_markets', value: 'Stamford', model: 'GradingNote', sort_order: 30, description: '' },
  { group: 'farmers_markets', value: 'West Bridgford', model: 'GradingNote', sort_order: 31, description: '' },
  { group: 'farmers_markets', value: 'Wollaton', model: 'GradingNote', sort_order: 32, description: '' }

 
]


Reference.create!(reference_data)

puts "✅ Reference values seeded successfully!"
