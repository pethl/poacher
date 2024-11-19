class TraceabilityRecord < ApplicationRecord
  belongs_to :makesheet
  has_many :waste_records, dependent: :destroy
 
  validates :makesheet_id, presence: true
  validates :date_started_batch, presence: true
  validates :individual_cheese_weight_1, numericality: { greater_than_or_equal_to: 0, less_than: BigDecimal(10**3) },
  format: { with: /\A\d{1,3}(\.\d{1,2})?\z/ }

  scope :ordered, -> { order(date_started_batch: :asc) }
end
