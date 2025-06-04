require "set"

puts "🧹 Clearing old Trolley and Shed locations..."
Location.where("name LIKE ?", "Trolley%")
        .or(Location.where("name LIKE ?", "Shed 4%"))
        .or(Location.where("name LIKE ?", "Shed 5%"))
        .delete_all

used_names = Set.new
used_orders = Set.new

# --- TROLLEYS ---
puts "🚚 Seeding Trolleys..."
trolley_order = 1
(1..60).each do |n|
  name = "Trolley #{n}"
  raise "Duplicate name: #{name}" if used_names.include?(name)
  raise "Duplicate sort_order: #{trolley_order}" if used_orders.include?(trolley_order)

  Location.create!(
    name: name,
    location_type: "Trolley",
    sort_order: trolley_order
  )

  used_names << name
  used_orders << trolley_order
  trolley_order += 1
end

# --- SHED 4 ---
puts "🏠 Seeding Shed 4..."
shed4_order = 4000
(1..6).each do |alley|
  %w[Left Right].each do |side|
    (1..28).each do |col|
      name = "Shed 4 - Alley #{alley} #{side} - Col #{col}"
      raise "Duplicate name: #{name}" if used_names.include?(name)
      raise "Duplicate sort_order: #{shed4_order}" if used_orders.include?(shed4_order)

      Location.create!(
        name: name,
        location_type: "Shed",
        sort_order: shed4_order
      )

      used_names << name
      used_orders << shed4_order
      shed4_order += 1
    end
  end
end

# --- SHED 5 ---
puts "🏠 Seeding Shed 5..."
shed5_order = 5000
(1..6).each do |alley|
  %w[Left Right].each do |side|
    (1..20).each do |col|
      name = "Shed 5 - Alley #{alley} #{side} - Col #{col}"
      raise "Duplicate name: #{name}" if used_names.include?(name)
      raise "Duplicate sort_order: #{shed5_order}" if used_orders.include?(shed5_order)

      Location.create!(
        name: name,
        location_type: "Shed",
        sort_order: shed5_order
      )

      used_names << name
      used_orders << shed5_order
      shed5_order += 1
    end
  end
end

puts "✅ Done seeding locations: #{Location.count} total"
