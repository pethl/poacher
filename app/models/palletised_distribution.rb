class PalletisedDistribution < ApplicationRecord
  include UserTrackable

  belongs_to :user, optional: true

  belongs_to :created_by, class_name: "User", optional: true
  belongs_to :updated_by, class_name: "User", optional: true

  scope :ordered, -> { order(date: :desc) }

  FIELDS_TO_CHECK = %i[
    company_name
    registration
    trailer_number_type
    temperature
    vehicle_clean
    destination
    number_of_pallets
    user_id
    staff_signature
    driver_signature
  ].freeze

  before_validation :set_default_date_if_needed

  validate :at_least_one_field_present

  private

  def set_default_date_if_needed
    self.date ||= Date.current if fields_filled?
  end

  def fields_filled?
    FIELDS_TO_CHECK.any? { |field| self[field].present? }
  end

  def at_least_one_field_present
    return if date.present? || fields_filled?

    errors.add(:base, "No fields entered – nothing to save!")
  end
end