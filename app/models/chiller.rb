class Chiller < ApplicationRecord
  include UserTrackable
  belongs_to :staff, optional: true
  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :updated_by, class_name: 'User', optional: true

  validate :required_fields_on_edit

  scope :ordered, -> { order(date: :asc) }

  scope :filter_by_month_and_year, ->(month, year) {
    where('EXTRACT(MONTH FROM date) = ? AND EXTRACT(YEAR FROM date) = ?', month, year)
  }

  def required_fields_on_edit
    return if new_record?
  
    errors.add(:base, "Chiller 1 is required") if chiller_1.blank?
    errors.add(:base, "Chiller 2 is required") if chiller_2.blank?
    errors.add(:base, "Staff must be selected") if staff_id.blank?
    errors.add(:base, "Signature is required") if signature.blank?
  end 
end
