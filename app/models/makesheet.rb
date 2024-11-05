class Makesheet < ApplicationRecord
  has_many :turns
  
  validates :make_date, presence: true
  
  scope :ordered, -> { order(make_date: :asc) }
   
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
  
  def batch_and_grade
    if self.grade?
     self.batch + " " + self.grade
    else
      self.batch
    end 
  end
 
end
