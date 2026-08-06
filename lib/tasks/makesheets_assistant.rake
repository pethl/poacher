namespace :makesheets_assistant do
  desc "Copy assistant staff links to assistant user links"

  task migrate_to_users: :environment do
    updated = 0

    Makesheet.find_each do |makesheet|
      staff = Staff.find_by(id: makesheet.assistant_staff_id)

      makesheet.update_columns(
        assistant_user_id: staff&.user_id
      )

      updated += 1 if staff&.user_id.present?
    end

    puts "✅ Updated #{updated} makesheets"
  end
end