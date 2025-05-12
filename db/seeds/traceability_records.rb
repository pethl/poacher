puts "🌱 Seeding Traceability Records..."

TraceabilityRecord.destroy_all

record_count = 10

# Select oldest makesheets based on make_date
available_makesheets = Makesheet.order(:make_date).limit(record_count)

available_makesheets.each_with_index do |makesheet, i|
  cheese_count = rand(18..30)

  # Target ~20kg total ± 1.5kg
  target_total = (200 + rand(-1.5..1.5)).round(2)
  avg_weight = (target_total / cheese_count.to_f).round(2)

  cheese_weights = Array.new(cheese_count) { (avg_weight + rand(-0.05..0.05)).round(2) }
  total_weight = cheese_weights.sum.round(2)

  weight_fields = {}
  (1..35).each do |n|
    weight_fields["individual_cheese_weight_#{n}".to_sym] = cheese_weights[n - 1] if n <= cheese_count
  end

  TraceabilityRecord.create!(
    makesheet_id: makesheet.id,
    date_started_batch: makesheet.make_date,
    date_finished_batch: makesheet.make_date + rand(1..2).days,
    all_rinds_visually_clean: [true, false].sample.to_s,
    confirmed_number_of_cheeses: cheese_count,
    total_weight_of_batch: total_weight,
    **weight_fields,
    created_at: Time.zone.now,
    updated_at: Time.zone.now
  )
end

puts "✅ Seeded #{record_count} traceability records from oldest makesheets."

