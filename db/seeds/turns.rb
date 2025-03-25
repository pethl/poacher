# db/seeds/turns.rb

puts "✨ Seeding Turns..."

Turn.destroy_all

turn_count = 0

makesheets = Makesheet.all

makesheets.each do |ms|
  turn_start_date = ms.make_date + 4.days

  # First 3 weekly turns — done by "Hand"
  3.times do |i|
    turn_date = turn_start_date + i.weeks
    break if turn_date > Date.today

    Turn.create!(
      turn_date: turn_date,
      turned_by: "Hand",
      makesheet: ms
    )
    turn_count += 1
  end

  # Monthly turns after that — done by "Florence"
  month_index = 1
  loop do
    turn_date = turn_start_date + 3.weeks + month_index.months
    break if turn_date > Date.today

    Turn.create!(
      turn_date: turn_date,
      turned_by: "Florence",
      makesheet: ms
    )
    turn_count += 1
    month_index += 1
  end
end

puts "✅ Turns seeded: #{turn_count}"
