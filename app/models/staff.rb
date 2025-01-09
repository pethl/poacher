class Staff < ApplicationRecord
  has_many :chillers
 
    
  validates :employment_status, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  
  scope :ordered, -> { order(last_name: :asc) }

  def full_name
    "#{self.first_name} #{self.last_name}"

  end
end 
