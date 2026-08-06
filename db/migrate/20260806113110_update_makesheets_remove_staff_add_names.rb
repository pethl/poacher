class UpdateMakesheetsRemoveStaffAddNames < ActiveRecord::Migration[7.1]
  def change
    add_reference :makesheets,
                  :assistant_user,
                  foreign_key: { to_table: :users }
  end
end
