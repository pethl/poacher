class PicksheetItem < ApplicationRecord
   belongs_to :picksheet
   
    scope :ordered, -> { order(id: :asc) }
end
