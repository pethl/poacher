# frozen_string_literal: true

require 'rails_helper'
require 'tempfile'

RSpec.describe MilkQualityMonitor, type: :model do
  describe '.import' do
    it 'adds new rows and skips duplicates by sample_date and makesheet_id' do
      csv = nil

     base_date = 5.years.from_now.beginning_of_day

      m1 = create(:makesheet, make_date: base_date)
      m2 = create(:makesheet, make_date: base_date + 1.day)

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

      expect(
        described_class.pluck(:sample_date, :makesheet_id)
      ).to contain_exactly(
        [Date.parse('2025-01-01'), m1.id],
        [Date.parse('2025-01-02'), m2.id]
      )
    ensure
      csv&.close!
    end

    it 'skips rows that fail validation' do
      csv = nil

      csv = Tempfile.new(['monitor', '.csv'])
      csv.write(<<~CSV)
        sample_date,makesheet_id,cell_count,bactoscan
        2025-01-01,,not-a-number,200
      CSV
      csv.flush

      file = double('File', path: csv.path)

      expect(described_class.import(file)).to eq(added: 0, skipped: 1)
      expect(described_class.count).to eq(0)
    ensure
      csv&.close!
    end
  end
end