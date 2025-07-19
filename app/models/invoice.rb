class Invoice < ApplicationRecord
  include UserTrackable
  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :updated_by, class_name: 'User', optional: true
  
  validates :number, presence: true
  validates :date, presence: true

  scope :ordered, -> { order(number: :asc) }
end
