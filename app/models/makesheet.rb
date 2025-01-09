class Makesheet < ApplicationRecord
  has_many :turns
  has_many :traceability_records
  
  validates :make_date, presence: true
  
  scope :ordered, -> { order(make_date: :asc) }
   
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
