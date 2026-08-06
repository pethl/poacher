# app/models/cheese_wash_record.rb
class CheeseWashRecord < ApplicationRecord
  include UserTrackable

  belongs_to :makesheet
  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :updated_by, class_name: 'User', optional: true

  validates :makesheet_id, presence: { message: "Makesheet must be selected before saving the wash record." }
  validates :makesheet_id, uniqueness: { message: "This batch already has a wash record." }
  # 🚫 Prevent marking batch as finished unless fully washed
  validate :cannot_finish_until_fully_washed

  scope :ordered, -> { order(date_batch_started: :asc) }
  MAX_WASH_ENTRIES = 24

  def total_washed
      (1..MAX_WASH_ENTRIES).sum { |i| self["number_washed_#{i}"].to_i }
    end

    def wash_date_range
      dates = (1..MAX_WASH_ENTRIES).map { |i| self["wash_date_#{i}"] }.compact
      dates.min..dates.max unless dates.empty?
    end

  def remaining_to_wash
    makesheet.number_of_cheeses.to_i - total_washed
  end


  private

    def cannot_finish_until_fully_washed
      return unless date_batch_finished.present?
      return if remaining_to_wash.zero?

      errors.add(
        :date_batch_finished,
        "Washed cheese count must match the makesheet count before setting the finish date."
      )
    end
end
