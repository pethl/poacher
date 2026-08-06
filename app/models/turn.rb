class Turn < ApplicationRecord
  include UserTrackable

  TURN_METHODS = [
    "Manual",
    "Florence"
  ].freeze

  belongs_to :makesheet
  belongs_to :turned_by,
             class_name: "User",
             optional: true

  belongs_to :created_by,
             class_name: "User",
             optional: true

  belongs_to :updated_by,
             class_name: "User",
             optional: true

  validates :turn_date,
          presence: { message: "Please enter the turn date." }

  validates :turn_method,
          presence: { message: "Please select how the cheeses were turned." },
          inclusion: { in: TURN_METHODS }

validates :turned_by,
          presence: { message: "Please select who turned the cheeses." },
          if: -> { turn_method == "Manual" }

  validates :turn_date,
          uniqueness: {
            scope: :makesheet_id,
            message: "This batch has already been turned on this date."
          }

  scope :ordered, -> { order(turn_date: :desc) }

  def turned_by_display
    return "Florence" if turn_method == "Florence"

    turned_by&.full_name
  end
end
