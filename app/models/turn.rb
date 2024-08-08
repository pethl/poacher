class Turn < ApplicationRecord
  belongs_to :makesheet
  
  def date_and_grade
    self.turn_date.to_formatted_s(:uk_day)+" "+self.makesheet.batch
  end
end
