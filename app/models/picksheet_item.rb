class PicksheetItem < ApplicationRecord
   belongs_to :picksheet
   
    validates :product, presence: true
    validates :size, presence: true
    validates :count, presence: true
   
    scope :ordered, -> { order(id: :asc) }
    
    def previous_id
       picksheet.picksheet_items.ordered.where("id < ?", id).last
     end
     
     def get_weight
       product = self.product
       size = self.size
       count= self.count.to_f
       converter =Calculation.where(product: product, size: size).pluck(:weight)
      (count*converter.first.to_f)/1000
     end   
     
end
