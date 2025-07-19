class Wash < ApplicationRecord
  include UserTrackable
  has_many :wash_picksheets
  has_many :picksheets, through: :wash_picksheets
  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :updated_by, class_name: 'User', optional: true

  scope :ordered, -> { order(action_date: :asc) }
end
