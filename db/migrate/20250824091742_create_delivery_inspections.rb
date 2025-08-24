class CreateDeliveryInspections < ActiveRecord::Migration[7.1]
  def change
    create_table :delivery_inspections do |t|
      t.date :delivery_date
      t.string :item
      t.string :batch_no
      t.date :best_before
      t.boolean :cert_received
      t.boolean :damage
      t.boolean :foreign_contam
      t.boolean :pest_contam
      t.boolean :timely_delivery
      t.boolean :satisfactory
      t.text :comments
      t.references :staff, null: false, foreign_key: true
      t.string :staff_signature

      t.timestamps
    end
  end
end
