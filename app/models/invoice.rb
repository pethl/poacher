class Invoice < ApplicationRecord
  validates :number, presence: true
  validates :date, presence: true

  scope :ordered, -> { order(number: :asc) }
end
