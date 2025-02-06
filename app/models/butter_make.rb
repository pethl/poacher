class ButterMake < ApplicationRecord
  validates :date, presence: true, uniqueness: true

  scope :ordered, -> { order(date: :asc) }

  def stock_calc
    #butter stock calculation: yesterdays stock level + todays cream( - todays make (if any))
    yesterdays_date = self.date-1.day
    yesterdays_stock = ButterMake.find_by(date: yesterdays_date)
    # need the if to manage the start point as start doesn't have a yesterday
    if yesterdays_stock
      yesterdays_stock= yesterdays_stock.stock.to_i
    else
      yesterdays_stock = 2
    end

    if self.cream.nil? || yesterdays_stock.nil? ||  self.make.nil?
      return
    else
      return self.cream + yesterdays_stock - self.make
    end
    
  end

end
