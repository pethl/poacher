class Turn < ApplicationRecord
  belongs_to :makesheet
  
   validates :turn_date, presence: true
   validates :makesheet_id, presence: true
   
  
  def date_and_grade
    self.turn_date.to_formatted_s(:uk_day)+" "+self.makesheet.batch
  end
  
   scope :ordered, -> { order(turn_date: :desc) }
end
