class ReplaceStaffWithUserOnChillers < ActiveRecord::Migration[7.1]
  def change
    remove_column :chillers, :staff_id, :bigint

    add_reference :chillers, :user, foreign_key: true

    add_index :chillers, :date
  end
end
