class ReplaceStaffWithUsersOnCleaningForeignBodyChecks < ActiveRecord::Migration[7.1]
  def change
    remove_column :cleaning_foreign_body_checks, :staff_id, :bigint
    remove_column :cleaning_foreign_body_checks, :staff_id_2, :bigint
    remove_column :cleaning_foreign_body_checks, :staff_id_3, :bigint

    add_reference :cleaning_foreign_body_checks, :user, foreign_key: true
    add_reference :cleaning_foreign_body_checks, :user_2, foreign_key: { to_table: :users }
    add_reference :cleaning_foreign_body_checks, :user_3, foreign_key: { to_table: :users }

    add_index :cleaning_foreign_body_checks, :date
  end
end
