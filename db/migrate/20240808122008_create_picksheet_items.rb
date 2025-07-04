class CreatePicksheetItems < ActiveRecord::Migration[7.0]
  def change
    create_table :picksheet_items do |t|
      t.references :picksheet, null: false, foreign_key: true
      t.references :makesheet, null: true, foreign_key: true  # Make this optional
      t.string :product
      t.string :size
      t.integer :count
      t.decimal :weight, precision: 7, scale: 2
      t.string :code
      t.decimal :sp_price, precision: 7, scale: 2
      t.datetime :bb_date
     
      t.string :pricing
      t.string :custom_notes

      t.timestamps
    end
  end
end
