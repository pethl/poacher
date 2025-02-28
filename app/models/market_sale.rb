class MarketSale < ApplicationRecord
  validates :market, presence: true
  validates :sale_date, presence: true

   # Scope for sorting by sale_date and market (A-Z)
   scope :sorted_by_date_and_market, -> { order(sale_date: :asc, market: :asc) }

   def self.sales_by_market_and_month
    select("market, EXTRACT(MONTH FROM sale_date) AS month, SUM(total_sales) AS total_sales")
      .where(sale_date: Date.new(2023, 1, 1)..Date.new(2023, 12, 31))
      .group("market, month")
      .order("market ASC, month")
  end

end
