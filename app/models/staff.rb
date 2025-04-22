class Staff < ApplicationRecord
  has_many :chillers
  has_many :breakages
  has_many :cheese_makes, class_name: 'Makesheet', foreign_key: 'cheese_made_by_staff_id'
  has_many :assists, class_name: 'Makesheet', foreign_key: 'assistant_staff_id'

    
  validates :employment_status, presence: true
  validates :first_name, presence: { message: "First name is required" }
  validates :last_name, presence: { message: "Last name is required" }
  
  scope :ordered, -> { order(last_name: :asc) }

  def full_name
    "#{self.first_name} #{self.last_name}"

  end
  
  def initials
    "#{self.first_name.chr}." + " " + "#{self.last_name.chr}"

  end
end 
