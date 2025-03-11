class AddCustomerToMakesheets < ActiveRecord::Migration[7.1]
  def change
    add_reference :makesheets, :contact, null: true, foreign_key: true
  end
end
