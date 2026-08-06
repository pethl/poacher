namespace :staff do
  desc "Create users from staff records and link staff"
  task migrate_to_users: :environment do

    Staff.find_each do |staff|

      if staff.user.present?
        puts "SKIP #{staff.full_name} - already linked"
        next
      end

      # Match existing users first
      user = User.find_by(
        first_name: staff.first_name,
        last_name: staff.last_name
      )

      unless user
        email = "#{staff.first_name.downcase}.#{staff.last_name.downcase}@example.com"

        user = User.create!(
          first_name: staff.first_name,
          last_name: staff.last_name,
          email: email,
          password: SecureRandom.hex(12),
          dept: staff.dept,
          title: staff.role,
          employment_status: staff.employment_status,
          account_active: staff.employment_status == "Active"
        )

        puts "CREATED #{user.full_name}"
      else
        puts "FOUND #{user.full_name}"
      end

      staff.update!(user: user)

      puts "LINKED #{staff.full_name}"
    end

    puts "Done. Linked staff: #{Staff.where.not(user_id: nil).count}"
  end
end