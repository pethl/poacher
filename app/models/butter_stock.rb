class ButterStock < ApplicationRecord
  include UserTrackable
  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :updated_by, class_name: 'User', optional: true
  
  validates :make_date, presence: true

  scope :ordered, -> { order(make_date: :asc) }
end
