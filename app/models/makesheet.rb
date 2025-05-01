class Makesheet < ApplicationRecord
  has_many :turns
  has_many :traceability_records
  has_many :batch_weights 
  has_and_belongs_to_many :samples
  
  has_one :grading_note, dependent: :destroy
  belongs_to :pre_start_inspection_by_staff, class_name: 'Staff', foreign_key: 'pre_start_inspection_by_staff_id', optional: true
  belongs_to :cheese_made_by_staff, :class_name => 'Staff', :foreign_key => 'cheese_made_by_staff_id', optional: true
  belongs_to :contact, optional: true
  
  validates :make_date, presence: true, uniqueness: { message: "has already been taken. There cannot be two makesheets with the same date." }
  validates :make_type, presence: true
  
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

  def make_date_formatted_and_grade
    "#{make_date.strftime('%d-%b')} – Batch #{batch} (#{grade.presence || 'Ungraded'})"
  end

  def make_date_formatted_batch_grade
    "#{make_date.strftime('%d-%b')} – Batch #{batch} (#{grade.presence || 'Ungraded'})"
  end


  def yield
    return 0 if milk_used.to_f.zero?
    (total_weight.to_f / milk_used.to_f) * 100
  end

  # Class method for average yield per make_type (last N makesheets)
  def self.average_yield_for(make_type, limit = 10, exclude_id = nil)
    sheets = where(make_type: make_type)
    sheets = sheets.where.not(id: exclude_id) if exclude_id
    sheets = sheets.order(created_at: :desc).limit(limit)

    return nil if sheets.empty?

    sheets.map(&:yield).sum / sheets.size
  end

  # Instance method for predicted yield (excluding self)
  def predicted_yield
    Makesheet.average_yield_for(self.make_type, 10, self.id)
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
  
  def batch_and_grade
    if self.grade?
     self.batch + " " + self.grade
    else
      self.batch
    end 
  end

end
