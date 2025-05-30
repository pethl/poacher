# db/seeds/location.rb

Location.delete_all

# Clear old if needed
Location.where("name LIKE ?", "Trolley%").or(Location.where("name LIKE ?", "Shed%")).delete_all

# --- TROLLEYS ---
(1..60).each do |n|
  Location.create!(
    name: "Trolley #{n}",
    location_type: "Trolley"
  )
end

# --- SHED 4 ---
shed_4_alleys = (1..6) # or adjust as needed
(1..6).each do |alley|
  %w[Left Right].each do |side|
    (1..28).each do |col|
      Location.create!(
        name: "Shed 4 - Alley #{alley} #{side} - Col #{col}",
        location_type: "Shed"
      )
    end
  end
end

# --- SHED 5 ---
(1..6).each do |alley|
  %w[Left Right].each do |side|
    (1..20).each do |col|
      Location.create!(
        name: "Shed 5 - Alley #{alley} #{side} - Col #{col}",
        location_type: "Shed"
      )
    end
  end
end
