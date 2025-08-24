class DeliveryInspection < ApplicationRecord
  belongs_to :staff

  validates :delivery_date,  presence: { message: "Delivery date must be provided" }
  validates :item,           presence: { message: "Item must be selected" }
  validates :batch_no,       presence: { message: "Batch No. must be entered" }
  validates :best_before,    presence: { message: "Best before date must be entered" }
  validates :cert_received,  inclusion: { in: [true, false], message: "must be specified" }
  validates :damage,         inclusion: { in: [true, false], message: "must be specified" }
  validates :foreign_contam, inclusion: { in: [true, false], message: "must be specified" }
  validates :pest_contam,    inclusion: { in: [true, false], message: "must be specified" }
  validates :satisfactory,   inclusion: { in: [true, false], message: "must be specified" }
 
  validates :staff_id,       presence: { message: "is required" }
  validates :staff_signature, presence: { message: "please sign" }

  # custom validation
  validate :best_before_cannot_be_in_past

  scope :by_delivery_date_desc, -> {
    order(Arel.sql("delivery_date DESC NULLS LAST, created_at DESC"))
  }

  private

  def best_before_cannot_be_in_past
    return if best_before.blank?
    if best_before < Date.current
      errors.add(:best_before, "cannot be before today")
    end
  end

end
