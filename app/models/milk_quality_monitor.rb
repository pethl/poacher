class MilkQualityMonitor < ApplicationRecord
  include UserTrackable
  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :updated_by, class_name: 'User', optional: true
  
  belongs_to :makesheet, optional: true

  scope :ordered, -> { order(sample_date: :desc) }

  def self.import(file)
    added = 0
    skipped = 0
  
    CSV.foreach(file.path, headers: true) do |row|
      sample_date = row["sample_date"]
      makesheet_id = row["makesheet_id"]
  
      # Skip if a record already exists with same sample_date and makesheet_id
      if where(sample_date: sample_date, makesheet_id: makesheet_id).exists?
        skipped += 1
        next
      end
  
      monitor = new
      monitor.attributes = row.to_hash.slice(
        "sample_date", "makesheet_id", "cell_count", "bactoscan",
        "butterfat", "lactose", "protein", "casein", "urea",
        "total_viable_colonies", "therms", "coliforms"
      )
  
      if monitor.save
        added += 1
      else
        skipped += 1
      end
    end
  
    { added: added, skipped: skipped }
  end

  def self.rolling_geo_avg_bactoscan
    results = []
  
    all.order(:sample_date).pluck(:sample_date).uniq.each do |date|
      range_start = date - 2.months
      values = where(sample_date: range_start..date).pluck(:bactoscan).compact
  
      next if values.empty? || values.any? { |v| v <= 0 }
  
      log_sum = values.map { |v| Math.log10(v) }.sum
      geo_mean = 10 ** (log_sum / values.size)
  
      results << { date: date, geo_mean: geo_mean.round(2), count: values.size }
    end
  
    results
  end
  
end
