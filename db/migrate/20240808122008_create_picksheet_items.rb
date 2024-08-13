class CreatePicksheetItems < ActiveRecord::Migration[7.0]
  def change
    create_table :picksheet_items do |t|
      t.references :picksheet, null: false, foreign_key: true
      t.string :product
      t.string :size
      t.integer :count
      t.decimal :weight
      t.string :code
      t.decimal :sp_price
      t.datetime :bb_date

      t.timestamps
    end
  end
end
