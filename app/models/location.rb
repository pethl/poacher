class Location < ApplicationRecord
  include UserTrackable
  has_one :makesheet
  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :updated_by, class_name: 'User', optional: true

  validates :name, presence: true, uniqueness: true
  validates :sort_order, presence: true, uniqueness: true

  scope :active, -> { where(active: true) }
  scope :active_sorted, -> { active.order(:sort_order) }

  def shed
    name[/Shed (\d+)/i, 1]
  end

  def aisle
    name[/Aisle (\d+)/i, 1]&.to_i
  end

  def side
    name[/Aisle \d+ (Left|Right)/i, 1]
  end

  def column_number
    name[/Col (\d+)/i, 1]&.to_i
  end

  def row_label
    "Aisle #{aisle} #{side}" if aisle && side
  end

  def shed_number
    # Only extract if it's a shed (e.g., "Shed 5 - Aisle 1 Right")
    if name =~ /Shed (\d+)/
      $1.to_i
    else
      nil
    end
  end

  def trolley_number
    name[/Trolley (\d+)/i, 1]&.to_i
  end

 
end

