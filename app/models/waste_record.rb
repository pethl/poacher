class WasteRecord < ApplicationRecord
  include UserTrackable
  belongs_to :traceability_record
  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :updated_by, class_name: 'User', optional: true

  validates :waste_date,
  presence: true,
  uniqueness: {
    scope: :traceability_record_id,
    message: "A waste record for this date is already present."
  }

  scope :ordered, -> { order(waste_date: :asc) }

end
