class GradingNote < ApplicationRecord
  include UserTrackable
  belongs_to :makesheet
  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :updated_by, class_name: 'User', optional: true
  belongs_to :head_taster,
           class_name: "User"

  validates :head_taster,
          presence: { message: "Please select the Head Taster." }

  accepts_nested_attributes_for :makesheet, update_only: true

  # app/models/grading_note.rb
    scope :ordered_by_makesheet_date, -> {
      joins(:makesheet).order("makesheets.make_date DESC")
    }
  

  # Optional: validate presence of makesheet_id (this is redundant
  # if your migration enforces it, but can be good for clarity)
  validates :makesheet, presence: { message: "Makesheet must be selected" }
  validates :head_taster, presence: { message: "Head Taster must be selected — someone has to lead the tasting!" }

end
