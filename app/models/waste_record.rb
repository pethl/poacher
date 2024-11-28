class WasteRecord < ApplicationRecord
  belongs_to :traceability_record

  validates :waste_date, presence: true, uniqueness: { scope: :traceability_record_id }

  scope :ordered, -> { order(waste_date: :asc) }

end
