class MarketSale < ApplicationRecord
  include UserTrackable
  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :updated_by, class_name: 'User', optional: true
  
  validates :market, presence: { message: "Market must be entered." }
  validates :sale_date, presence: { message: "Sale Date must be entered." }
  validates :total_sales,
          presence:     { message: "Total sales must be entered." },
          numericality: { message: "Total sales must be a valid number." }

   # Scope for sorting by sale_date and market (A-Z)
   scope :sorted_by_date_and_market, -> { order(sale_date: :asc, market: :asc) }

   def self.sales_by_market_and_month(year = Date.current.year)
      select("market,
              EXTRACT(MONTH FROM sale_date) AS month,
              SUM(total_sales) AS total_sales")
        .where(sale_date: Date.new(year, 1, 1)..Date.new(year, 12, 31))
        .group("market, month")
        .order("market ASC, month ASC")
    end

end
