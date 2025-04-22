class PalletisedDistribution < ApplicationRecord
  belongs_to :staff, optional: true
  scope :ordered, -> { order(date: :desc) }

   # Assuming these are the fields you're working with:
   FIELDS_TO_CHECK = [
    :company_name, :registration, :trailer_number_type, :temperature, 
    :vehicle_clean, :destination, :number_of_pallets,
    :staff_id, :staff_signature, :driver_signature
  ]

  before_validation :set_default_date_if_needed

  # Prevent saving if no fields at all (including date)
  validate :at_least_one_field_present

  private

  def set_default_date_if_needed
    if date.blank? && fields_filled?
      self.date = Date.today
    end
  end

  def fields_filled?
    FIELDS_TO_CHECK.any? { |field| self[field].present? }
  end

  def at_least_one_field_present
    unless date.present? || fields_filled?
      errors.add(:base, "No fields entered – nothing to save!")
    end
  end
end
