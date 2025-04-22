class Calculation < ApplicationRecord
  validates :product, presence: true
  validates :size, presence: true
  validates :weight, presence: true
  
  scope :ordered, -> { order(product: :asc, weight: :desc, id: :asc) }

end
