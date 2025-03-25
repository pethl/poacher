# db/seeds/calculations.rb

puts "✨ Seeding Calculations..."

Calculation.destroy_all

calculations_data = [
  # Poacher
  ['Poacher', 'Whole', 20000], ['Poacher', '1/2', 10100], ['Poacher', '1/4', 5050], ['Poacher', '1/8', 2500],
  ['Poacher', '100g', 100], ['Poacher', '200g', 200], ['Poacher', '300g', 300],

  # Vintage
  ['Vintage', 'Whole', 20200], ['Vintage', '1/2', 10200], ['Vintage', '1/4', 5100], ['Vintage', '1/8', 2500],
  ['Vintage', '100g', 100], ['Vintage', '200g', 200], ['Vintage', '300g', 300],

  # P50
  ['P50', 'Whole', 20200], ['P50', '1/2', 10200], ['P50', '1/4', 5100], ['P50', '1/8', 2500],
  ['P50', '100g', 100], ['P50', '200g', 200], ['P50', '300g', 300],

  # Red
  ['Red', 'Whole', 10200], ['Red', '1/2', 5200], ['Red', '1/4', 2500], ['Red', '1/8', 1200],
  ['Red', '100g', 100], ['Red', '200g', 200], ['Red', '300g', 300],

  # Smoked
  ['Smoked', 'Whole', 10200], ['Smoked', '1/2', 5200], ['Smoked', '1/4', 2500], ['Smoked', '1/8', 1200],
  ['Smoked', '100g', 100], ['Smoked', '200g', 200], ['Smoked', '300g', 300],

  # Double Barrel
  ['Double Barrel', 'Whole', 10200], ['Double Barrel', '1/2', 5200], ['Double Barrel', '1/4', 2500], ['Double Barrel', '1/8', 1200],
  ['Double Barrel', '100g', 100], ['Double Barrel', '200g', 200], ['Double Barrel', '300g', 300]
]

calculations_data.each do |product, size, weight|
  Calculation.create!(product: product, size: size, weight: weight)
end

puts "✅ Calculations seeded: #{Calculation.count}"
