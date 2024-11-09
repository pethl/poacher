class ButterStock < ApplicationRecord
  validates :make_date, presence: true

  scope :ordered, -> { order(make_date: :asc) }
end
