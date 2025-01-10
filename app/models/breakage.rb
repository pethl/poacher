class Breakage < ApplicationRecord
  belongs_to :staff, optional: true

  scope :ordered, -> { order(date: :asc) }
end
