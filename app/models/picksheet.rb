class Picksheet < ApplicationRecord
  has_many :picksheet_items, dependent: :destroy
  has_many :wash_picksheets
  has_many :washes, through: :wash_picksheets
  belongs_to :user
  belongs_to :contact
  
  validates :date_order_placed, presence: true
  validates :contact_id, presence: true
   
  scope :ordered, -> { order(date_order_placed: :asc) }
   
   def picksheet_title_detail
    "Due: #{self.delivery_required_by.strftime('%b %d, %Y')} - #{self.contact.business_name}, Products: #{self.number_of_products}"
   end
     
  def number_of_products
    self.picksheet_items.count
  end

  def full_delivery_info
  delivery_date = self.delivery_required_by.present? ? self.delivery_required_by.to_datetime.strftime('%b %d, %Y') : ""
  delivery_time = self.delivery_time_of_day.presence ? " (#{self.delivery_time_of_day})" : ""
  full_delivery_info = "#{delivery_date}#{delivery_time}"

  end

end
