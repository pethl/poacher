class Picksheet < ApplicationRecord
  has_many :picksheet_items, dependent: :destroy
  has_many :wash_picksheets
  has_many :washes, through: :wash_picksheets
  
  validates :date_order_placed, presence: true
   
  scope :ordered, -> { order(delivery_required_by: :desc) }
   
   def picksheet_title_detail
       "- #{self.id}- #{self.delivery_required_by.strftime('%b %d, %Y')} - #{self.contact_telephone_number} - Products #{self.number_of_products}"
       #THIS NEED CUSTOMER NAME ADDING, NOT YET THERE
     end
     
     def number_of_products
       self.picksheet_items.count
     end
end
