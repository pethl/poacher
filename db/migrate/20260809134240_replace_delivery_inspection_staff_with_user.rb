class ReplaceDeliveryInspectionStaffWithUser < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :delivery_inspections, :staffs

    remove_reference :delivery_inspections,
                     :staff,
                     null: false

    add_reference :delivery_inspections,
                  :user,
                  null: false,
                  foreign_key: true
  end
end
