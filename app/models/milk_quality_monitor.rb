class MilkQualityMonitor < ApplicationRecord
  belongs_to :makesheet, optional: true

  scope :ordered, -> { order(sample_date: :desc) }
end
