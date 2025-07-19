class Picksheet < ApplicationRecord
  include UserTrackable
  has_many :picksheet_items, dependent: :destroy
  has_many :wash_picksheets
  has_many :washes, through: :wash_picksheets
  belongs_to :user
  belongs_to :contact
  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :updated_by, class_name: 'User', optional: true
  

  
  validates :date_order_placed, presence: true
  validates :contact_id, presence: true
   
  scope :ordered, -> { order(date_order_placed: :asc) }
   
   def picksheet_title_detail
    "Due: #{self.delivery_required_by&.strftime('%b %d, %Y')} - #{self.contact.business_name}, Products: #{self.number_of_products}"
   end
     
  def number_of_products
    self.picksheet_items.count
  end

  def number_of_items
    picksheet_items.sum(:count)
  end

  def total_weight_kg
    picksheet_items.includes(:picksheet).sum do |item|
      item.get_weight.to_f
    end.round(2)
  end

  def full_delivery_info
    return "" unless delivery_required_by.present?
  
    delivery_date = delivery_required_by.strftime('%b %d, %Y')
    delivery_time = delivery_time_of_day.present? ? " (#{delivery_time_of_day})" : ""
    "#{delivery_date}#{delivery_time}"
  end

end
