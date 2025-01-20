class Picksheet < ApplicationRecord
  has_many :picksheet_items, dependent: :destroy
  has_many :wash_picksheets
  has_many :washes, through: :wash_picksheets
  belongs_to :contact
  
  validates :date_order_placed, presence: true
  validates :contact_id, presence: true
   
  scope :ordered, -> { order(delivery_required_by: :desc) }
   
   def picksheet_title_detail
    "Due: #{self.delivery_required_by.strftime('%b %d, %Y')} - #{self.contact.business_name}, Products: #{self.number_of_products}"
   end
     
  def number_of_products
    self.picksheet_items.count
  end
end
