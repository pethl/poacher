class Makesheet < ApplicationRecord
  has_many :turns
  has_many :traceability_records
  has_many :samples  
  belongs_to :pre_start_inspection_by_staff, class_name: 'Staff', foreign_key: 'pre_start_inspection_by_staff_id', optional: true
  belongs_to :cheese_made_by_staff, :class_name => 'Staff', :foreign_key => 'cheese_made_by_staff_id', optional: true
  has_many :staffs  
  
  validates :make_date, presence: true
  validates :make_type, presence: true
  
  scope :ordered, -> { order(make_date: :asc) }
  scope :ordered_reverse, -> { order(make_date: :desc) }

  # Scope to filter out "Finished" status
  scope :not_finished, -> { where.not(status: "Finished") }

  scope :filter_by_month_and_year, ->(month, year) {
    where('EXTRACT(MONTH FROM make_date) = ? AND EXTRACT(YEAR FROM make_date) = ?', month, year)
  }
   
  def make_date_formatted
    self.make_date.to_formatted_s(:uk_clean_date)
  end

  def make_date_formatted_batch_grade
    self.make_date.to_formatted_s(:uk_clean_date) + " ["+self.batch_and_grade+"]"
  end

  def yield
    (self.total_weight.to_f/(self.milk_used.to_f)*100)
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
