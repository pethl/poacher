class RenameStaffToUserOnPalletisedDistributions < ActiveRecord::Migration[7.1]
 
  def change
    remove_foreign_key :palletised_distributions, :staffs

    rename_column :palletised_distributions, :staff_id, :user_id

    add_foreign_key :palletised_distributions,
                    :users,
                    column: :user_id
  end
end