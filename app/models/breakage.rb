class Breakage < ApplicationRecord
  belongs_to :staff, optional: true

  scope :ordered, -> { order(date: :asc) }

  scope :filter_by_month_and_year, ->(month, year) {
    where('EXTRACT(MONTH FROM date) = ? AND EXTRACT(YEAR FROM date) = ?', month, year)
  }
end
