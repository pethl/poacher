class ButterMake < ApplicationRecord
  validates :date, presence: true

  scope :ordered, -> { order(date: :asc) }
end
