class PicksheetItem < ApplicationRecord
   belongs_to :picksheet
   belongs_to :makesheet, optional: true  # Ensure this line exists!
   
    validates :product, presence: true, unless: -> { makesheet_id.present? }
    validates :makesheet_id, presence: true, unless: -> { product.present? }
    validates :size, presence: true
    validates :count, presence: true, unless: -> { custom_notes.present? }
    validates :custom_notes, presence: true, unless: -> { count.present? }
   
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

     def display_product_or_grade
      makesheet_id.present? ? "#{makesheet.grade} #{makesheet.make_date.strftime('%d/%m/%y')}" : product

    end
     
end
