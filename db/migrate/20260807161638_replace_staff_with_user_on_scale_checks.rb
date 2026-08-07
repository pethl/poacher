class ReplaceStaffWithUserOnScaleChecks < ActiveRecord::Migration[7.1]
  def change
    remove_column :scale_checks, :staff_id, :bigint

    add_reference :scale_checks, :user, foreign_key: true
    add_index :scale_checks, :check_date
  end
end
