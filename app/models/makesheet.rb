class Makesheet < ApplicationRecord
  include UserTrackable
  has_many :turns
  has_many :traceability_records
  has_many :batch_weights 
  has_and_belongs_to_many :samples
  has_one :grading_note, dependent: :destroy

  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :updated_by, class_name: 'User', optional: true
  belongs_to :pre_start_inspection_by_staff, class_name: 'Staff', foreign_key: 'pre_start_inspection_by_staff_id', optional: true
  belongs_to :cheese_made_by_staff, :class_name => 'Staff', :foreign_key => 'cheese_made_by_staff_id', optional: true
  belongs_to :contact, optional: true
  belongs_to :location, optional: true
  
  validates :make_date, presence: true, uniqueness: { message: "has already been taken. There cannot be two makesheets with the same date." }
  validates :make_type, presence: true
  validates :location_id, uniqueness: true, allow_nil: true

  
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
      sixth_cut_time,
      fifth_cut_time,
      fourth_cut_time,
      third_cut_time,
      second_cut_time,
      first_cut_time
    ].compact.max
  
    latest_time&.strftime("%H:%M")
  end


end
