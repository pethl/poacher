class MarketSale < ApplicationRecord
  validates :market, presence: true
  validates :sale_date, presence: true

   # Scope for sorting by sale_date and market (A-Z)
   scope :sorted_by_date_and_market, -> { order(sale_date: :asc, market: :asc) }
end
