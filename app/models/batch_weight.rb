class BatchWeight < ApplicationRecord
  belongs_to :makesheet, optional: true

  validates :makesheet_id, presence: true, uniqueness: true #custom error message in locale/en.yml
  validates :date, presence: true

  scope :ordered, -> { order(date: :asc) }
  #scope :not_finished, -> { where.not(status: "Finished") } believe this is worong
  scope :not_finished, -> { joins(:makesheet).where.not(makesheets: { status: "Finished" }) }

   # After creating a BatchWeight, update the associated Makesheet's status to "Finished"
   after_create :mark_makesheet_as_finished

   def weight_minus_waste
    washed_batch_weight.to_f - total_waste.to_f
  end

  def waste_percentage
    return 0.0 if washed_batch_weight.to_f.zero?
    return 0.0 if total_waste.to_f.zero?
  
    ((total_waste.to_f / washed_batch_weight.to_f) * 100).round(2)
  end

   private
 
   def mark_makesheet_as_finished
    raise "No makesheet associated" unless makesheet
    makesheet.update!(status: 'Finished')
  end
end
