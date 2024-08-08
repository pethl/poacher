class CreatePicksheets < ActiveRecord::Migration[7.0]
  def change
    create_table :picksheets do |t|
      t.datetime :date_order_placed
      t.datetime :delivery_required_by
      t.string :order_number
      t.string :contact_telephone_number
      t.string :invoice_number
      t.string :carrier
      t.datetime :carrier_delivery_date
      t.integer :number_of_boxes

      t.timestamps
    end
  end
end
