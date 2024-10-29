class Contact < ApplicationRecord
  has_many :picksheet

  scope :ordered, -> { order(business_name: :asc) }
end 
