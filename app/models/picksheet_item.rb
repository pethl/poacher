class PicksheetItem < ApplicationRecord
   belongs_to :picksheet
   
    validates :product, presence: true
    validates :size, presence: true
    validates :count, presence: true
   
    scope :ordered, -> { order(id: :asc) }
    
    def previous_id
       picksheet.picksheet_items.ordered.where("id < ?", id).last
     end
end
