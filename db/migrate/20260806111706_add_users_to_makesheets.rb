class AddUsersToMakesheets < ActiveRecord::Migration[7.1]
  def change
    add_reference :makesheets,
                  :cheese_made_by_user,
                  foreign_key: { to_table: :users }

    add_reference :makesheets,
                  :pre_start_inspection_by_user,
                  foreign_key: { to_table: :users }

    add_reference :makesheets,
                  :pre_start_inspection_by_2_user,
                  foreign_key: { to_table: :users }
  end
end
