class CreateInvoices < ActiveRecord::Migration[7.1]
  def change
    create_table :invoices do |t|
      t.integer :number
      t.string :account
      t.date :date
      t.decimal :amount, precision: 7, scale: 2
      t.decimal :weight, precision: 7, scale: 2

      t.timestamps
    end
  end
end
