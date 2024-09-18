class Makesheet < ApplicationRecord
  has_many :turns
  
  validates :make_date, presence: true
  
 
  def yield
    self.milk_used/self.total_weight #THIS IS NOT THE RIGHT CALC
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
  
  def batch_and_grade
    if self.grade?
     self.batch + " " + self.grade
    else
      self.batch
    end 
  end
 
end
