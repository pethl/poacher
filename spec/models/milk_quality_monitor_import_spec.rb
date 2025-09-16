# frozen_string_literal: true
require 'rails_helper'
require 'tempfile'

RSpec.describe MilkQualityMonitor, type: :model do
  describe '.import' do
    it 'adds new and skips duplicates by [sample_date, makesheet_id]' do
      # Create minimal valid makesheets (match your model validations)
      m1 = Makesheet.create!(make_type: 'Cheddar', make_date: Time.zone.now)
      m2 = Makesheet.create!(make_type: 'Cheddar', make_date: Time.zone.now)

      csv = Tempfile.new(['monitor', '.csv'])
      csv.write(<<~CSV)
        sample_date,makesheet_id,cell_count,bactoscan,butterfat,lactose,protein,casein,urea,total_viable_colonies,therms,coliforms
        2025-01-01,#{m1.id},100,200,3.5,4.2,3.3,2.2,15,1000,10,5
        2025-01-01,#{m1.id},100,200,3.5,4.2,3.3,2.2,15,1000,10,5
        2025-01-02,#{m2.id},110,300,3.6,4.1,3.2,2.1,14,900,9,4
      CSV
      csv.flush

      file = double('File', path: csv.path)
      result = described_class.import(file)

      expect(result).to eq(added: 2, skipped: 1)
      expect(described_class.count).to eq(2)
      expect(described_class.pluck(:sample_date, :makesheet_id)).to contain_exactly(
        [Date.parse('2025-01-01'), m1.id],
        [Date.parse('2025-01-02'), m2.id]
      )
    ensure
      csv&.close!  # guard in case the example failed before csv was created
    end
  end
end


