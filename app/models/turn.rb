class Turn < ApplicationRecord
  include UserTrackable
  belongs_to :makesheet
  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :updated_by, class_name: 'User', optional: true
  
   validates :turn_date, presence: true
   validates :makesheet_id, presence: true
   
  
  def date_and_grade
    self.turn_date.to_formatted_s(:uk_day)+" "+self.makesheet.batch
  end
  
   scope :ordered, -> { order(turn_date: :desc) }
end
