class BatchWeight < ApplicationRecord
  belongs_to :makesheet, optional: true

  validates :makesheet_id, presence: true, uniqueness: true #custom error message in locale/en.yml
  validates :date, presence: true

  scope :ordered, -> { order(date: :asc) }
  #scope :not_finished, -> { where.not(status: "Finished") } believe this is worong
  scope :not_finished, -> { joins(:makesheet).where.not(makesheets: { status: "Finished" }) }

   # After creating a BatchWeight, update the associated Makesheet's status to "Finished"
   after_create :mark_makesheet_as_finished

   private
 
   def mark_makesheet_as_finished
     makesheet.update(status: 'Finished')
   end
end
