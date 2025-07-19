class TraceabilityRecord < ApplicationRecord
  include UserTrackable
  belongs_to :makesheet, optional: true
  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :updated_by, class_name: 'User', optional: true
  
  has_many :waste_records, dependent: :destroy
 
  validates :makesheet_id,
  presence: { message: "Please select a Makesheet" },
  uniqueness: { message: "This Makesheet has already been used for another record" }

    validates :date_started_batch,
      presence: { message: "Start date is required" }

    # Validate all cheese weights (1 to 35)
    (1..35).each do |i|
      validates :"individual_cheese_weight_#{i}",
        numericality: {
          greater_than_or_equal_to: 0,
          less_than: BigDecimal(10**2),
          message: "Cheese weight must be a number between 0 and 99.99"
        },
        allow_nil: true
    end

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

  def total_waste #used by cheese batch weights dont delete ever
    waste_types = %i[wedges cooking blue t_and_bs waste]
    waste_values = WasteRecord.where(traceability_record_id: id).pluck(*waste_types)
    waste_values.flatten.compact.sum
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
