class Location < ApplicationRecord
  has_one :makesheet

  validates :name, presence: true, uniqueness: true
  validates :sort_order, presence: true, uniqueness: true

  scope :active, -> { where(active: true) }
   # New scope: active and sorted
  scope :active_sorted, -> { active.order(:sort_order) }

  
  def shed
    name[/Shed (\d+)/i, 1]
  end
  
  def alley
    name[/Alley (\d+)/i, 1]
  end
  
  def side
    name[/Alley \d+ (Left|Right)/i, 1]
  end
  
  def column_number
    name[/Col (\d+)/i, 1]&.to_i
  end
  
  def row_label
    "Alley #{alley} #{side}" if alley && side
  end
end
