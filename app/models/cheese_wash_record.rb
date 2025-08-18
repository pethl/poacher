# app/models/cheese_wash_record.rb
class CheeseWashRecord < ApplicationRecord
  include UserTrackable

  belongs_to :makesheet, optional: true
  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :updated_by, class_name: 'User', optional: true

  validates :makesheet_id, presence: { message: "Makesheet must be selected before saving the wash record." }
  validates :makesheet_id, uniqueness: { message: "This batch already has a wash record." }

  scope :ordered, -> { order(date_batch_started: :asc) }

  def total_washed
    (1..24).sum { |i| self["number_washed_#{i}"].to_i }
  end

  def wash_date_range
    dates = (1..24).map { |i| self["wash_date_#{i}"] }.compact
    dates.min..dates.max unless dates.empty?
  end

  def remaining_to_wash
    makesheet.number_of_cheeses.to_i - total_washed
  end

  # 🚫 Prevent marking batch as finished unless fully washed
  validate :cannot_finish_until_fully_washed

  private

  def cannot_finish_until_fully_washed
    if date_batch_finished.present? && remaining_to_wash != 0
      errors.add(:date_batch_finished, "Cheeses remaining, please check count - can't set Finish Date")
    end
  end
end
