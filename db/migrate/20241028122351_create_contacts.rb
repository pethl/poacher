class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.string :business_name
      t.string :contact_name
      t.string :reference
      t.string :email
      t.string :mobile
      t.string :phone
      t.string :country
      t.string :address
      t.boolean :pre_payment
      t.boolean :payment_on_receipt
      t.integer :days_after_invoice
      t.string :terms_and_conditions
      t.boolean :sage_delivery_note
      t.text :notes

      t.timestamps
    end
  end
end
