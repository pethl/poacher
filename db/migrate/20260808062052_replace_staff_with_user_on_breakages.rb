class ReplaceStaffWithUserOnBreakages < ActiveRecord::Migration[7.1]
  def change
    remove_column :breakages, :staff_id, :bigint

    add_reference :breakages, :user, foreign_key: true
    add_index :breakages, :date
  end
end
