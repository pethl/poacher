class Location < ApplicationRecord
  include UserTrackable
  has_one  :makesheet         # for aisle and future trolleys
  has_many :all_makesheets, class_name: "Makesheet"
  
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

  # def column_number
  #   name[/Col (\d+)/i, 1]&.to_i
  # end

   # Numeric column for sorting (nil if not numeric)
   def column_number
    m = name.match(/Col(?:umn)?\.?\s*-?\s*([0-9]+)/i) # Col 3, Col3, Col-3, Column 3
    m && m[1].to_i
  end

  # Label for display (handles digits OR letters)
  def column_label
    m = name.match(/Col(?:umn)?\.?\s*-?\s*([A-Za-z0-9]+)/i) # Col A, Col 10, Column 3, Col-7
    m && m[1].upcase
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

