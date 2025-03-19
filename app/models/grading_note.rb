class GradingNote < ApplicationRecord
  belongs_to :makesheet

  accepts_nested_attributes_for :makesheet, update_only: true

  # Associate head_taster and assistant tasters to Staff.
  # We mark these associations as optional (or remove optional: true if you require them)
  belongs_to :head_taster_staff, class_name: "Staff", foreign_key: "head_taster", optional: true
  belongs_to :assistant_taster_staff_1, class_name: "Staff", foreign_key: "assistant_taster_1", optional: true
  belongs_to :assistant_taster_staff_2, class_name: "Staff", foreign_key: "assistant_taster_2", optional: true

  # Optional: validate presence of makesheet_id (this is redundant
  # if your migration enforces it, but can be good for clarity)
  validates :makesheet, presence: true
end
