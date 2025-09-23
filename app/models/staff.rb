class Staff < ApplicationRecord
  include UserTrackable
  has_many :chillers
  has_many :breakages
  has_many :cheese_makes, class_name: 'Makesheet', foreign_key: 'cheese_made_by_staff_id'
  has_many :assists, class_name: 'Makesheet', foreign_key: 'assistant_staff_id'
  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :updated_by, class_name: 'User', optional: true

    
  validates :employment_status, presence: true
  validates :first_name, presence: { message: "First name is required" }
  validates :last_name, presence: { message: "Last name is required" }
  
  scope :ordered, -> { order(first_name: :asc) }

  scope :cutting_room, -> { where(dept: 'Cutting Room', employment_status: 'Active') }
  scope :cheesemaking, -> { where(dept: 'Cheesemaking Team', employment_status: 'Active') }
  scope :office,       -> { where(dept: 'Office', employment_status: 'Active') }
  scope :butter,       -> { where(dept: 'Butter', employment_status: 'Active') }
  scope :all_active,       -> { where( employment_status: 'Active') }
  


  def full_name
    "#{self.first_name} #{self.last_name}"

  end
  
  def initials
    "#{self.first_name.chr}." + "#{self.last_name.chr}."
  end
end 
