namespace :makesheets do
  desc "Copy Staff references to User references on makesheets"
  task migrate_staff_to_users: :environment do

    Makesheet.find_each do |makesheet|

      if makesheet.cheese_made_by_staff_id.present?
        user_id = Staff.find_by(id: makesheet.cheese_made_by_staff_id)&.user_id
        makesheet.update_column(:cheese_made_by_user_id, user_id) if user_id
      end

      if makesheet.pre_start_inspection_by_staff_id.present?
        user_id = Staff.find_by(id: makesheet.pre_start_inspection_by_staff_id)&.user_id
        makesheet.update_column(:pre_start_inspection_by_user_id, user_id) if user_id
      end

      if makesheet.pre_start_inspection_by_2_staff_id.present?
        user_id = Staff.find_by(id: makesheet.pre_start_inspection_by_2_staff_id)&.user_id
        makesheet.update_column(:pre_start_inspection_by_2_user_id, user_id) if user_id
      end

    end

    puts "Migration complete"
  end
end