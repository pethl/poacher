class CreateButterStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :butter_stocks do |t|
      t.datetime :make_date
      t.integer :todays_make
      t.integer :fresh_spare_for_sale
      t.integer :market_returns_salted
      t.integer :market_returns_hm2
      t.integer :market_returns_unsalted
      t.integer :freezer_stock_salted
      t.integer :freezer_stock_hm2
      t.integer :freezer_stock_unsalted
      t.integer :family_butter_salted
      t.integer :family_butter_hm2
      t.integer :family_butter_unsalted

      t.timestamps
    end
  end
end
