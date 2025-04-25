class ScaleCheck < ApplicationRecord
  belongs_to :staff, optional: true

  validates :scale_name, :check_date, :frequency, presence: true
  validates :check_date, uniqueness: { scope: [:scale_name, :frequency], message: "Already have a record for this scale and date." }
  validates :staff_id, presence: { message: "Please identify yourself from the Staff list." }
 
end
