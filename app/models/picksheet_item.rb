class PicksheetItem < ApplicationRecord
   belongs_to :picksheet
   
    scope :ordered, -> { order(id: :asc) }
    
    def previous_id
       picksheet.picksheet_items.ordered.where("id < ?", id).last
     end
end
