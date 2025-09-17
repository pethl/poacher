class Makesheet < ApplicationRecord
  include UserTrackable
  has_many :turns
  has_many :traceability_records
  has_many :batch_weights 
  has_many :ingredient_batch_changes, dependent: :destroy
  has_many :delivery_inspections, through: :ingredient_batch_changes

  has_and_belongs_to_many :samples
  has_one :grading_note, dependent: :destroy

  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :updated_by, class_name: 'User', optional: true
  belongs_to :pre_start_inspection_by_staff, class_name: 'Staff', foreign_key: 'pre_start_inspection_by_staff_id', optional: true
  belongs_to :pre_start_inspection_by_2_staff, class_name: 'Staff', foreign_key: 'pre_start_inspection_by_2_staff_id', optional: true

  belongs_to :cheese_made_by_staff, :class_name => 'Staff', :foreign_key => 'cheese_made_by_staff_id', optional: true
  belongs_to :contact, optional: true
  belongs_to :location, optional: true
  
  validate :validate_fields_against_ranges
  validates :make_date, presence: true, uniqueness: { message: "This date has already been taken. There cannot be two makesheets with the same date." }
  validates :make_type, presence: { message: "must be selected – please choose a make type." }
  
  # REMOVED AS A BIT TOO COMPLEX TO IMPLEMNET AND NOT OFTEN OCCURING ALSO BUILT REPORTS INSTEAD
  #validates :location_id, uniqueness: true, allow_nil: true
 
  # Scopes
  scope :ordered, -> { order(make_date: :asc) }
  scope :ordered_reverse, -> { order(make_date: :desc) }
  scope :not_finished, -> { where.not(status: "Finished") }
  scope :filter_by_month_and_year, ->(month, year) {
    where('EXTRACT(MONTH FROM make_date) = ? AND EXTRACT(YEAR FROM make_date) = ?', month, year)
  }


  def progress
      if make_type.present? && milk_used.present? && salt_weight_net? && type_of_starter_culture_used? && qty_of_starter_used?
        if first_cut_time.present? && second_cut_time.present? && third_cut_time? && fourth_cut_time?
          if total_weight.present? && number_of_cheeses.present? 
            if pre_start_inspection_by_staff_id.present?
              return "IV"  # All conditions met
            end
            return "III"  # Everything except pre_start_inspection_by_staff_id
          end
          return "II"  # Everything except total_weight and number_of_cheeses
        end
        return "I"  # Only make_type and milk_used are present
      end
      return "N"  # No progress 
    end
  
  
  def make_date_formatted
    self.make_date.to_formatted_s(:uk_clean_date)
  end

  def make_date_formatted_and_type
    return nil unless make_date.present?
  
    #formatted datae returns Tues 7th Sept 2024
    formatted_date = make_date.to_formatted_s(:uk_day)
    type = make_type.presence || "Unknown"
    "#{formatted_date} (#{type})"
  end

  def make_date_formatted_and_grade
    "#{make_date.strftime('%d-%b')} – Batch #{batch} #{grade.presence || 'Ungraded'}"
  end

  def make_date_formatted_batch_grade
    "#{make_date.strftime('%d-%b')} – Batch #{batch} #{grade.presence || 'Ungraded'}"
  end

  def make_date_batch_grade
    "#{make_date.strftime('%d-%b')} [Batch #{batch}] #{grade.presence || 'Ungraded'}"
  end

  def batch_and_grade
    "#{make_date.strftime('%d-%b')} [#{batch}]"
  end


  def yield
    return 0 if milk_used.to_f.zero?
    (total_weight.to_f / milk_used.to_f) * 100
  end
 
  # Average yield of the last N makesheets with make_date <= today.
  # Optionally exclude a specific record (used by #predicted_yield).
  def self.average_recent_yield(limit = 10, exclude_id: nil)
    scope = where('make_date < ?', Date.today)  # strictly prior to today
    scope = scope.where.not(id: exclude_id) if exclude_id
    sheets = scope.order(make_date: :desc).limit(limit)
    return nil if sheets.empty?
    sheets.map(&:yield).sum / sheets.size
  end

  # Predicted yield uses the same recent window, excluding self.
  def predicted_yield
    Makesheet.average_recent_yield(10, exclude_id: id)
  end

  def calc_salt_net
    yield_value = expected_yield.presence || predicted_yield
    return 0 if milk_used.to_f.zero? || yield_value.to_f.zero?
  
    salt_factor = (make_type == "Red") ? 0.00021 : 0.0002
    milk_used.to_f * yield_value.to_f * salt_factor
  end

  def calc_salt_gross
    bucket_weight_value = Reference.where(active: true, group: 'bucket_weight').pluck(:value).first.to_f
    calc_salt_net.to_f + bucket_weight_value
  end
  
  def age_in_days
    (Date.today - self.make_date.to_date).to_i 
  end
  
  def age_in_weeks
    ((Date.today - self.make_date.to_date)/7).to_i
  end
  
  def age_in_months
    ((Date.today - self.make_date.to_date)/30).to_i
  end

  def make_month
    self.make_date.strftime("%B %Y")
  end

 

  def cleaning_status
    check = CleaningForeignBodyCheck.find_by(date: make_date)
    return 'Not Started' unless check
  
    cleaning_fields = %i[
      milk_pipeline cheese_vat used_mill cooler_moulds_tables hand_equipment
      blue_food_contact_equipment plastic_sleeves metal_shovels aprons
      drain_lower_level drain_upper_level presses sinks floor_difficult_areas
      footbaths internal_door_handles change_chlorine floor_under_handwash compressors
    ]
  
    values = cleaning_fields.map { |field| check.send(field) }
  
    if values.all?
      'Complete'
    elsif values.any?
      'Incomplete'
    else
      'Not Started'
    end
  end

  def the_final_titration
    [
      seventh_cut_titration,  
      sixth_cut_titration,
      fifth_cut_titration,
      fourth_cut_titration,
      third_cut_titration,
      second_cut_titration,
      first_cut_titration
    ].compact.first
  end

  def total_time
    latest_time = [
      seventh_cut_time,
      sixth_cut_time,
      fifth_cut_time,
      fourth_cut_time,
      third_cut_time,
      second_cut_time,
      first_cut_time
    ].compact.max
  
    latest_time&.strftime("%H:%M")
  end

  def flags
    f = []
    f << "Slow" if slow_cheese
    f << "Metal" if metal_contamination
    f << "Glass" if glass_breakage
  
    # Check if samples are preloaded
    if samples.loaded?
      first_sample = samples.first
    else
      first_sample = samples.limit(1).first
    end
  
    if first_sample
      f << "<a href='/samples/#{first_sample.id}' class='underline text-blue-600'>Sample</a>"
    end
  
    f.join(", ").html_safe
  end
  
  def validate_fields_against_ranges
    # Only validate numeric fields that have a range
    ValidationRange.where(active: true).each do |range|
      field = range.field_name
  
      next unless self.has_attribute?(field)
  
      value = self[field]
  
      # Skip blank or non-numeric values
      next if value.blank? || !value.is_a?(Numeric)
  
      if range.min_value.present? && value < range.min_value
        errors.add(:base, "#{field.humanize} is below the minimum of #{range.min_value}")
      end
  
      if range.max_value.present? && value > range.max_value
        errors.add(:base, "#{field.humanize} is above the maximum of #{range.max_value}")
      end
    end
  end
end
