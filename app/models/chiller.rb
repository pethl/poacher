class Chiller < ApplicationRecord
  belongs_to :staff, optional: true

  validate :staff_id_required_if_chillers_present

  scope :ordered, -> { order(date: :asc) }

  scope :filter_by_month_and_year, ->(month, year) {
    where('EXTRACT(MONTH FROM date) = ? AND EXTRACT(YEAR FROM date) = ?', month, year)
  }

   # Custom validation logic
   def staff_id_required_if_chillers_present
    if chiller_1.present? && chiller_2.present? && staff_id.blank?
      errors.add(:staff_id, "name is required before record can be saved.")
    end
  end
end
