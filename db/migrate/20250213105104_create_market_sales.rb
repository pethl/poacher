class CreateMarketSales < ActiveRecord::Migration[7.0]
  def change
    create_table :market_sales do |t|
      t.string :who
      t.string :market
      t.date :sale_date
      t.decimal :cheese_sales, precision: 7, scale: 2  # Max 9999.99
      t.decimal :butter_sales, precision: 7, scale: 2  # Max 9999.99
      t.decimal :honey_sales, precision: 7, scale: 2  # Max 9999.99
      t.decimal :egg_sales, precision: 7, scale: 2  # Max 9999.99
      t.decimal :plum_bread, precision: 7, scale: 2  # Max 9999.99
      t.decimal :milk, precision: 7, scale: 2  # Max 9999.99
      t.decimal :other_cheese, precision: 7, scale: 2  # Max 9999.99
      t.decimal :total_sales, precision: 7, scale: 2  # Max 9999.99
      t.decimal :weight, precision: 7, scale: 2  # Max 9999.99

      t.timestamps
    end

    add_index :market_sales, :sale_date  # Speeds up date-based queries  
    add_index :market_sales, [:market, :sale_date]  # Optimized for filtering by market & date  

  end
end
