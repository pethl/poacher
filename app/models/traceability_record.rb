class TraceabilityRecord < ApplicationRecord
  include UserTrackable

  belongs_to :makesheet
  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :updated_by, class_name: 'User', optional: true

  has_many :waste_records, dependent: :restrict_with_error

  before_validation :set_total_weight_of_batch
  before_validation :set_calculated_batch_values

  validates :makesheet_id,
            presence: { message: 'Please select a Makesheet' },
            uniqueness: { message: 'This Makesheet has already been used for another record' }

  validates :date_started_batch,
            presence: { message: 'Start date is required' }

  (1..35).each do |number|
    validates :"individual_cheese_weight_#{number}",
              numericality: {
                greater_than_or_equal_to: 0,
                less_than: BigDecimal(10**2),
                message: 'Cheese weight must be a number between 0 and 99.99'
              },
              allow_nil: true
  end

  scope :ordered, -> { order(date_started_batch: :asc) }

  def waste_records_total_wedges
    waste_records.sum(:wedges)
  end

  def waste_records_total_cooking
    waste_records.sum(:cooking)
  end

  def waste_records_total_blue
    waste_records.sum(:blue)
  end

  def waste_records_total_t_and_bs
    waste_records.sum(:t_and_bs)
  end

  def waste_records_total_waste
    waste_records.sum(:waste)
  end

  # Used by cheese batch weight calculations.
  def total_waste
    waste_records_total_wedges +
      waste_records_total_cooking +
      waste_records_total_blue +
      waste_records_total_t_and_bs +
      waste_records_total_waste
  end

  def calculated_batch_cheese_count
    individual_cheese_weights.compact.count
  end

  def calculated_batch_cheese_weight_total
    individual_cheese_weights.compact.sum
  end

  private

  def individual_cheese_weights
    (1..35).map do |number|
      public_send("individual_cheese_weight_#{number}")
    end
  end

  def set_total_weight_of_batch
    self.total_weight_of_batch = calculated_batch_cheese_weight_total
  end

  def set_calculated_batch_values
    self.confirmed_number_of_cheeses = calculated_batch_cheese_count
    self.total_weight_of_batch = calculated_batch_cheese_weight_total
  end
end