class GradingNote < ApplicationRecord
  include UserTrackable
  belongs_to :makesheet
  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :updated_by, class_name: 'User', optional: true

  accepts_nested_attributes_for :makesheet, update_only: true

  # app/models/grading_note.rb
    scope :ordered_by_makesheet_date, -> {
      joins(:makesheet).order("makesheets.make_date DESC")
    }

  # Associate head_taster and assistant tasters to Staff.
  # We mark these associations as optional (or remove optional: true if you require them)
  belongs_to :head_taster_staff, class_name: "Staff", foreign_key: "head_taster", optional: true
  belongs_to :assistant_taster_staff_1, class_name: "Staff", foreign_key: "assistant_taster_1", optional: true
  belongs_to :assistant_taster_staff_2, class_name: "Staff", foreign_key: "assistant_taster_2", optional: true

  # Optional: validate presence of makesheet_id (this is redundant
  # if your migration enforces it, but can be good for clarity)
  validates :makesheet, presence: { message: "Makesheet must be selected" }
  validates :head_taster, presence: { message: "Head Taster must be selected — someone has to lead the tasting!" }

end
