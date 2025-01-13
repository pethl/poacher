class PalletisedDistribution < ApplicationRecord
  belongs_to :staff, optional: true
  scope :ordered, -> { order(date: :desc) }
end
