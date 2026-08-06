namespace :makesheets_milling_help do
  desc "Copy Makesheet staff names into text fields before removing Staff references"

  task migrate_staff_names: :environment do
    updated = 0

    Makesheet.find_each do |makesheet|

      cheese_name =
        Staff.find_by(id: makesheet.cheese_made_by_staff_id)&.full_name

      assistant_name =
        Staff.find_by(id: makesheet.assistant_staff_id)&.full_name

      makesheet.update_columns(
        cheese_made_by_name: cheese_name,
        assistant_name: assistant_name
      )

      updated += 1
    end

    puts "✅ Updated #{updated} makesheets"
  end
end