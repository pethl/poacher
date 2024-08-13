class Picksheet < ApplicationRecord
  has_many :picksheet_items, dependent: :destroy
  
   validates :date_order_placed, presence: true
end
