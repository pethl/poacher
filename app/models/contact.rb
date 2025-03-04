class Contact < ApplicationRecord
  has_many :picksheets, foreign_key: :contact_id

  scope :ordered, -> { order(business_name: :asc) }
end 
