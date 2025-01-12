class BatchWeight < ApplicationRecord
  belongs_to :makesheet, optional: true

  scope :ordered, -> { order(date: :asc) }

  scope :not_finished, -> { where.not(status: "Finished") }
end
