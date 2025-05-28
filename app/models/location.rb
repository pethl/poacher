class Location < ApplicationRecord
  has_one :makesheet

  validates :name, presence: true, uniqueness: true

  scope :active, -> { where(active: true) }
end
