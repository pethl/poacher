class Calculation < ApplicationRecord
  include UserTrackable
  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :updated_by, class_name: 'User', optional: true
  
  validates :product, presence: true
  validates :size, presence: true
  validates :weight, presence: true
  
  scope :ordered, -> { order(product: :asc, weight: :desc, id: :asc) }

end
