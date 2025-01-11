class Sample < ApplicationRecord
  belongs_to :makesheet, optional: true
  validates :sample_no, uniqueness: true 

  scope :ordered, -> { order(sample_no: :asc) }

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Sample.create! row.to_hash
    end
  end

  # def self.import_data(file)
  #   spreadsheet = open_spreadsheet(file)
  #   header = spreadsheet.row(1)
  #   (2..spreadsheet.last_row).each do |i|
  #     row = Hash[[header, spreadsheet.row(i)].transpose]
  #     product = find_by_id(row["id"]) || new
  #     product.attributes = row.to_hash.slice(*accessible_attributes)
  #     product.save!
  #   end
  # end

end
 