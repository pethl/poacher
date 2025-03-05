class CreatePicksheets < ActiveRecord::Migration[7.0]
  def change
    create_table :picksheets do |t|
      t.datetime :date_order_placed
      t.datetime :delivery_required_by
      t.string :delivery_time_of_day
      t.string :order_number
      t.string :contact_telephone_number
      t.string :invoice_number
      t.string :carrier
      t.datetime :carrier_delivery_date
      t.string :carrier_collection_notes
      t.integer :number_of_boxes
      t.integer :contact_id, null: false  # Add contact_id as an integer
      t.string :status, default: "Open", null: false
      t.integer :user_id, null: false  # Add user_id as an integer

      t.timestamps
    end
  end
end
