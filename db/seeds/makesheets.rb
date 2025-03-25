# db/seeds/makesheets.rb

puts "✨ Seeding Makesheets..."

Makesheet.destroy_all

require 'date'

# Load weather references
weather_options = Reference.where(group: 'weather').pluck(:value)

# Select active cheesemakers
cheesemakers = Staff.where(dept: 'Cheesemaking Team', employment_status: 'Active').pluck(:id)

# UK seasonal weather mapping
SEASONAL_WEATHER = {
  winter: %w[Snow Fog Overcast Rain\ \(heavy\) Stormy],
  spring: %w[Sunny Cloudy Rain\ \(light\) Overcast],
  summer: %w[Sunny Cloudy Rain\ \(light\) Hail],
  autumn: %w[Overcast Cloudy Rain\ \(heavy\) Fog Stormy]
}

# Determine season from month
def season_for(month)
  case month
  when 12, 1, 2 then :winter
  when 3, 4, 5 then :spring
  when 6, 7, 8 then :summer
  else :autumn
  end
end

# Helper to assign grade
GRADES = {
  standard: {
    weighted: [
      ['Poacher', 60],
      ['Vintage', 20],
      ['Double Barrel', 5],
      ['Knuckle Duster', 5],
      ['Grating', 5],
      ['Poacher Leave', 2.5],
      ['Vintage Leave', 2.5]
    ]
  },
  red: 'Red',
  p50: 'P50'
}

def select_weighted(options)
  total = options.sum { |_, weight| weight }
  point = rand * total
  options.each do |value, weight|
    return value if point < weight
    point -= weight
  end
end

start_date = Date.today - 364
(0..364).each do |i|
  make_date = start_date + i
  milk_used = rand(5900..6300)

  # Make types and weights
  make_type = rand < 0.10 ? 'P50' : (rand < 0.10 ? 'Red' : 'Standard')
  weight_type = make_type == 'Red' ? 'Half Truckle (10kgs)' : 'Standard (20 kgs)'
  cheese_count = make_type == 'Red' ? rand(50..60) : rand(28..32)
  weight_per_cheese = make_type == 'Red' ? 10.05 : 20.05
  total_weight = (cheese_count * weight_per_cheese * rand(0.98..1.02)).round(2)

  # Weather info
  season = season_for(make_date.month)
  weather_today = SEASONAL_WEATHER[season].sample
  weather_temp = case season
                 when :winter then rand(-1.0..6.0).round(1)
                 when :spring then rand(7.0..14.0).round(1)
                 when :summer then rand(15.0..28.0).round(1)
                 when :autumn then rand(6.0..14.0).round(1)
                 end
  weather_humidity = rand(70..95)

  age_in_days = (Date.today - make_date).to_i
  age_in_months = (age_in_days / 30).floor

  status = if age_in_days < 21
             'Nursery'
           elsif age_in_days < 330
             'Store'
           elsif age_in_days < 360
             'Wash'
           else
             'Finished'
           end

  # Grade logic
  grade = nil
  if age_in_months >= 5
    grade = case make_type
            when 'P50' then GRADES[:p50]
            when 'Red' then GRADES[:red]
            else select_weighted(GRADES[:standard][:weighted])
            end
  end

  # Enforce grading for Wash or Finished
  if ['Wash', 'Finished'].include?(status) && grade.nil?
    grade = case make_type
            when 'P50' then GRADES[:p50]
            when 'Red' then GRADES[:red]
            else select_weighted(GRADES[:standard][:weighted])
            end
  end

  Makesheet.create!(
    make_date: make_date,
    status: status,
    make_type: make_type,
    milk_used: milk_used,
    total_weight: total_weight,
    number_of_cheeses: cheese_count,
    weight_type: weight_type,
    batch: (make_date + 6).strftime('%d-%m-%y'),
    grade: grade,
    weather_today: weather_today,
    weather_temp: weather_temp,
    weather_humidity: weather_humidity,
    cheese_made_by_staff_id: cheesemakers.sample
  )
end

puts "✅ Makesheets seeded: #{Makesheet.count}"
