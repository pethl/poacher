class PicksheetItem < ApplicationRecord
  include UserTrackable

  attr_accessor :wedge_size

  # Associations
  belongs_to :picksheet
  belongs_to :makesheet, optional: true
  belongs_to :created_by, class_name: "User", optional: true
  belongs_to :updated_by, class_name: "User", optional: true

  # Validations
  validates :product, presence: true, unless: -> { makesheet_id.present? }
  validates :makesheet_id, presence: true, unless: -> { product.present? }

  validate :validate_size_and_pricing
  validate :count_or_custom_note_must_be_present

  # Scopes
  scope :ordered, -> { order(id: :asc) }

  # Public methods
  def previous_id
    picksheet.picksheet_items.ordered.where("id < ?", id).last
  end

  def get_weight
    converter = Calculation.where(product: product, size: size).pluck(:weight).first.to_f
    (count.to_f * converter) / 1000
  end

  def display_product_or_grade
    makesheet_id.present? ? "#{makesheet.grade} #{makesheet.make_date.strftime('%d/%m/%y')}" : product
  end

  # Product type checkers
  def sale_product_requires_size?
    Reference.values_for("sale_product").include?(product)
  end

  def butter_product?
    Reference.values_for("sale_product_butter").include?(product)
  end

  def cut_guest_cheese?
    Reference.values_for("cut_guest_cheeses").include?(product)
  end

  def cheese_accompaniment?
    Reference.values_for("cheese_accompaniments").include?(product)
  end

  private

  # Validation helpers
  def validate_size_and_pricing
    return if product.blank?

    if cut_guest_cheese?
      errors.add(:size, "Size must be selected for cut guest cheeses") if size.blank?
    elsif sale_product_requires_size?
      if size.blank? && wedge_size.blank?
        errors.add(:size, "Size or wedge size must be selected")
      end

      if Reference.values_for("wedges_sizes").include?(size) && pricing.blank?
        errors.add(:pricing, "Pricing must be selected when a wedge size is chosen")
      end
    end
  end

  def count_or_custom_note_must_be_present
    if cheese_accompaniment?
      if count.to_s.strip.blank? || count.to_i <= 0
        errors.add(:count, "Count must be entered for cheese accompaniments")
      end
    elsif count.to_s.strip.blank? && custom_notes.to_s.strip.blank?
      errors.add(:count, "Count must be entered or add a custom note")
    end
  end
end
