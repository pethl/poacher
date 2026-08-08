class Reference < ApplicationRecord
  include UserTrackable

  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :updated_by, class_name: 'User', optional: true

  validates :model, presence: true
  validates :group, presence: true
  validates :value, presence: true
  validates :value, uniqueness: { scope: :group }

  #important do not delete - used in sale areas where heavy reliance on ref data
  scope :ordered, -> { order(sort_order: :asc) }
  scope :active, -> { where(active: true) }
  scope :for_group, ->(group) { where(group: group) }

  def self.values_for(group)
    active.for_group(group).ordered.pluck(:value)
  end
end
