puts "✨ Seeding Calculations..."

Calculation.destroy_all

products = ['Grated', 'Poacher', 'Vintage', 'P50', 'Knuckle Duster', 'Double Barrel', 'Red', 'Smoked']

cut_sizes = ['Whole', '1/2', '1/3 ring', '1/4', '1/8', '1/16']
wedge_sizes = [
  '10 x 200g', '100g', '150-175g min', '170-200g min', '180-250g min',
  '200g', '200g min', '200g approx', '200g-230g min', '200g-250g min',
  '200g-400g min', '225g-275g min', '250g', '250g-350g',
  '300g', '400-450g min', '500g', '750g', '1kg' # ← Added here
]

def wedge_weight(size)
  return 2000 if size.strip.downcase == '10 x 200g'
  return 1000 if size.strip.downcase == '1kg'

  size = size.strip.downcase

  if size =~ /(\d{2,4})g\s*[-–]\s*(\d{2,4})g/
    low, high = size.match(/(\d{2,4})g\s*[-–]\s*(\d{2,4})g/).captures.map(&:to_i)
    ((low + high) / 2.0).round
  elsif size =~ /(\d{2,4})g/ && size !~ /-/
    size.match(/(\d{2,4})g/)[1].to_i
  elsif size =~ /(\d+)\s*x\s*(\d+)g/
    count, gram = size.match(/(\d+)\s*x\s*(\d+)g/).captures.map(&:to_i)
    count * gram
  else
    0
  end
end

def fractional_weight(product, size)
  base_weight = product == "Red" ? 10200 : 20000
  case size
  when 'Whole' then base_weight
  when '1/2' then (base_weight / 2.0).round
  when '1/3 ring' then (base_weight / 3.0).round
  when '1/4' then (base_weight / 4.0).round
  when '1/8' then (base_weight / 8.0).round
  when '1/16' then (base_weight / 16.0).round
  else 0
  end
end

# Add Grated manually with its own 1kg entry
Calculation.create!(product: 'Grated', size: '1kg', weight: 1000)

# All other products
(products - ['Grated']).each do |product|
  (cut_sizes + wedge_sizes).each do |size|
    weight = cut_sizes.include?(size) ? fractional_weight(product, size) : wedge_weight(size)
    Calculation.create!(product: product, size: size, weight: weight)
  end
end

puts "✅ Calculations seeded: #{Calculation.count}"
