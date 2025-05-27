# app/models/cheese_wash_record.rb
class CheeseWashRecord < ApplicationRecord
  belongs_to :makesheet, optional: true

  validates :makesheet_id, presence: { message: "Makesheet must be selected before saving the wash record." }
  validates :makesheet_id, uniqueness: { message: "This batch already has a wash reocrd." }


  scope :ordered, -> { order(date_batch_started: :asc) }

  def total_washed
    (1..24).sum { |i| self["number_washed_#{i}"] || 0 }
  end

  def wash_date_range
    dates = (1..24).map { |i| self["wash_date_#{i}"] }.compact
    dates.min..dates.max unless dates.empty?
  end

  def remaining_to_wash
    makesheet.number_of_cheeses - total_washed
  end
end
