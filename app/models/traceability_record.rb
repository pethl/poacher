class TraceabilityRecord < ApplicationRecord
  belongs_to :makesheet
  has_many :waste_records, dependent: :destroy
 
  validates :makesheet_id, presence: true
  validates :date_started_batch, presence: true
  validates :individual_cheese_weight_1, numericality: { greater_than_or_equal_to: 0, less_than: BigDecimal(10**3) },
  format: { with: /\A\d{1,3}(\.\d{1,2})?\z/ }

  scope :ordered, -> { order(date_started_batch: :asc) }


  def waste_records_total_wedges
    @waste_records =  WasteRecord.where(traceability_record_id: self.id).pluck(:wedges)
    total = @waste_records.compact.sum
    return total
  end

  def waste_records_total_cooking
    @waste_records =  WasteRecord.where(traceability_record_id: self.id).pluck(:cooking)
    total = @waste_records.compact.sum
    return total
  end

  def waste_records_total_blue
    @waste_records =  WasteRecord.where(traceability_record_id: self.id).pluck(:blue)
    total = @waste_records.compact.sum
    return total
  end

  def waste_records_t_and_bs
    @waste_records =  WasteRecord.where(traceability_record_id: self.id).pluck(:t_and_bs)
    total = @waste_records.compact.sum
    return total
  end

  def waste_records_waste
    @waste_records =  WasteRecord.where(traceability_record_id: self.id).pluck(:waste)
    total = @waste_records.compact.sum
    return total
  end

  def calculated_batch_cheese_count
    # Define an array with a mix of integers, nil, and empty strings
    values = [self.individual_cheese_weight_1, 
              self.individual_cheese_weight_2,
              self.individual_cheese_weight_3,
              self.individual_cheese_weight_4,
              self.individual_cheese_weight_5,
              self.individual_cheese_weight_6,
              self.individual_cheese_weight_7,
              self.individual_cheese_weight_8,
              self.individual_cheese_weight_9,
              self.individual_cheese_weight_10,
              self.individual_cheese_weight_11,
              self.individual_cheese_weight_12,
              self.individual_cheese_weight_13,
              self.individual_cheese_weight_14,
              self.individual_cheese_weight_15,
              self.individual_cheese_weight_16,
              self.individual_cheese_weight_17,
              self.individual_cheese_weight_18,
              self.individual_cheese_weight_19,
              self.individual_cheese_weight_20,
              self.individual_cheese_weight_21,
              self.individual_cheese_weight_22,
              self.individual_cheese_weight_23,
              self.individual_cheese_weight_24,
              self.individual_cheese_weight_25,
              self.individual_cheese_weight_26,
              self.individual_cheese_weight_27,
              self.individual_cheese_weight_28,
              self.individual_cheese_weight_29,
              self.individual_cheese_weight_30,
              self.individual_cheese_weight_31,
              self.individual_cheese_weight_32,
              self.individual_cheese_weight_33,
              self.individual_cheese_weight_34,
              self.individual_cheese_weight_35
           ]

    # Count the number of present (non-empty) values
    present_count = values.count { |value| !value.nil? && value != "" }
    return present_count
   end

  def calculated_batch_cheese_weight_total
    # Define an array with a mix of integers, nil, and empty strings
    values = [self.individual_cheese_weight_1, 
              self.individual_cheese_weight_2,
              self.individual_cheese_weight_3,
              self.individual_cheese_weight_4,
              self.individual_cheese_weight_5,
              self.individual_cheese_weight_6,
              self.individual_cheese_weight_7,
              self.individual_cheese_weight_8,
              self.individual_cheese_weight_9,
              self.individual_cheese_weight_10,
              self.individual_cheese_weight_11,
              self.individual_cheese_weight_12,
              self.individual_cheese_weight_13,
              self.individual_cheese_weight_14,
              self.individual_cheese_weight_15,
              self.individual_cheese_weight_16,
              self.individual_cheese_weight_17,
              self.individual_cheese_weight_18,
              self.individual_cheese_weight_19,
              self.individual_cheese_weight_20,
              self.individual_cheese_weight_21,
              self.individual_cheese_weight_22,
              self.individual_cheese_weight_23,
              self.individual_cheese_weight_24,
              self.individual_cheese_weight_25,
              self.individual_cheese_weight_26,
              self.individual_cheese_weight_27,
              self.individual_cheese_weight_28,
              self.individual_cheese_weight_29,
              self.individual_cheese_weight_30,
              self.individual_cheese_weight_31,
              self.individual_cheese_weight_32,
              self.individual_cheese_weight_33,
              self.individual_cheese_weight_34,
              self.individual_cheese_weight_35
           ]
   
    # Calculate the total sum of existing values (ignoring nils and empty strings)
    total_sum = values.compact.sum
    return total_sum
  end
end
