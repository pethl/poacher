class PicksheetItem < ApplicationRecord
  attr_accessor :wedge_size

  belongs_to :picksheet
  belongs_to :makesheet, optional: true

  validates :product, presence: true, unless: -> { makesheet_id.present? }
  validates :makesheet_id, presence: true, unless: -> { product.present? }

  validate :validate_size_and_pricing
  validate :count_or_custom_note_must_be_present

  scope :ordered, -> { order(id: :asc) }

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

  # ---- Validation Helpers ----

  def validate_size_and_pricing
    return if product.blank?

    if cut_guest_cheese?
      errors.add(:size, "Size must be selected for cut guest cheeses") if size.blank?
    elsif sale_product_requires_size?
      if size.blank? && wedge_size.blank?
        errors.add(:size, "Size or wedge size must be selected")
      end
      if Reference.where(group: "wedges_sizes", active: true).pluck(:value).include?(size) && pricing.blank?
        errors.add(:pricing, "Pricing must be selected when a wedge size is chosen")
      end
    end
  end

  def count_or_custom_note_must_be_present
    if cheese_accompaniment?
      if count.to_s.strip.blank? || count.to_i <= 0
        errors.add(:count, "Count must be entered for cheese accompaniments")
      end
    else
      if count.to_s.strip.blank? && custom_notes.to_s.strip.blank?
        errors.add(:count, "Count must be entered or add a custom note")
      end
    end
  end

  # ---- Product Type Checkers ----

  def sale_product_requires_size?
    Reference.where(group: "sale_product", active: true).pluck(:value).include?(product)
  end

  def cut_guest_cheese?
    Reference.where(group: "cut_guest_cheeses", active: true).pluck(:value).include?(product)
  end

  def cheese_accompaniment?
    Reference.where(group: "cheese_accompaniments", active: true).pluck(:value).include?(product)
  end
end
