# app/models/ingredient_batch_change.rb
class IngredientBatchChange < ApplicationRecord
  belongs_to :makesheet
  belongs_to :delivery_inspection

  validates :item, presence: true
  validates :changed_on, presence: true
  validates :notes, length: { maximum: 1000 }, allow_blank: true

  validate :item_matches_delivery
  before_validation :default_changed_on
  before_validation :copy_item_from_delivery, if: -> { item.blank? && delivery_inspection.present? }

  # (optional) keep the legacy text field in sync for readability
  after_create :backfill_makesheet_text

  private

  def item_matches_delivery
    return if delivery_inspection.blank? || item.blank?
    errors.add(:item, "does not match the selected delivery’s item") if delivery_inspection.item != item
  end

  def default_changed_on
    self.changed_on ||= Date.current
  end

  def copy_item_from_delivery
    self.item = delivery_inspection.item
  end

  def backfill_makesheet_text
    return unless makesheet.respond_to?(:ingredient_batch_change)
    makesheet.update_column(
      :ingredient_batch_change,
      "#{item}: batch #{delivery_inspection.batch_no} (changed on #{changed_on})#{notes.present? ? " — #{notes}" : ""}"
    )
  end
end

