class RemoveStaffFieldsFromMakesheets < ActiveRecord::Migration[7.1]
  def change
    remove_column :makesheets, :pre_start_inspection_by_staff_id, :integer
    remove_column :makesheets, :cheese_made_by_staff_id, :integer
    remove_column :makesheets, :assistant_staff_id, :integer
    remove_column :makesheets, :pre_start_inspection_by_2_staff_id, :integer
  end
end
