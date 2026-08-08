class Breakage < ApplicationRecord
  include UserTrackable

  belongs_to :user, optional: true
  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :updated_by, class_name: 'User', optional: true

  scope :ordered, -> { order(date: :asc) }

  scope :filter_by_month_and_year, ->(month, year) {
    where('EXTRACT(MONTH FROM date) = ? AND EXTRACT(YEAR FROM date) = ?', month, year)
  }

  validates :date, presence: true
  # (not using due to the month create method) validates :user_id, presence: { message: "Please identify yourself." }
end
