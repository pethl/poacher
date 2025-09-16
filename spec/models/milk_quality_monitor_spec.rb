# frozen_string_literal: true
require 'rails_helper'

RSpec.describe MilkQualityMonitor, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:makesheet).optional }
  end

  describe 'database' do
    it { is_expected.to have_db_column(:sample_date).of_type(:date) }
    it { is_expected.to have_db_column(:makesheet_id).of_type(:integer) }
    it { is_expected.to have_db_column(:cell_count).of_type(:integer) }
    it { is_expected.to have_db_column(:bactoscan).of_type(:integer) }
    %i[
      butterfat lactose protein casein urea total_viable_colonies therms coliforms
    ].each do |col|
      it { is_expected.to have_db_column(col).of_type(:float) }
    end
  end

  # If your model already validates numbers, these will pass.
  # If not, comment them out and we’ll add the validations later.
  describe 'validations' do
    %i[cell_count bactoscan].each do |f|
      it { is_expected.to validate_numericality_of(f).only_integer.allow_nil }
    end
    %i[butterfat lactose protein casein urea total_viable_colonies therms coliforms].each do |f|
      it { is_expected.to validate_numericality_of(f).allow_nil }
    end
  end

  describe 'scopes' do
    describe '.ordered' do
      it 'returns newest-first by sample_date' do
        older  = described_class.create!(sample_date: Date.new(2024, 1, 1))
        newest = described_class.create!(sample_date: Date.new(2025, 3, 1))
        mid    = described_class.create!(sample_date: Date.new(2025, 1, 1))
  
        expect(described_class.ordered.pluck(:id)).to eq([newest.id, mid.id, older.id])
      end
    end
  end
  
  describe '.rolling_geo_avg_bactoscan' do
    it 'computes a 2-month rolling geometric mean per date (skipping <= 0)' do
      # three monthly points all > 0
      jan = described_class.create!(sample_date: Date.new(2025, 1, 1), bactoscan: 100)
      feb = described_class.create!(sample_date: Date.new(2025, 2, 1), bactoscan: 1000)
      mar = described_class.create!(sample_date: Date.new(2025, 3, 1), bactoscan: 100)
  
      results = described_class.rolling_geo_avg_bactoscan
      # results is an array of hashes like: { date:, geo_mean:, count: }
  
      by_date = results.index_by { |h| h[:date] }
  
      # For Jan 1: only Jan is within [Nov 1..Jan 1] → mean = 100, count = 1
      expect(by_date[Date.new(2025, 1, 1)]).to include(geo_mean: 100.0, count: 1)
  
      # For Feb 1: window [Dec 1..Feb 1] includes Jan + Feb → sqrt(100*1000) ≈ 316.23
      expect(by_date[Date.new(2025, 2, 1)]).to include(geo_mean: 316.23, count: 2)
  
      # For Mar 1: window [Jan 1..Mar 1] includes Jan + Feb + Mar
      # (100 * 1000 * 100) ** (1/3) ≈ 215.44
      expect(by_date[Date.new(2025, 3, 1)]).to include(geo_mean: 215.44, count: 3)
    end
  
    it 'skips a date if any value in its 2-month window is <= 0' do
      # Window for Apr 1 contains this zero → should skip Apr entirely
      described_class.create!(sample_date: Date.new(2025, 3, 15), bactoscan: 0)
      described_class.create!(sample_date: Date.new(2025, 4, 1),  bactoscan: 500)
  
      dates = described_class.rolling_geo_avg_bactoscan.map { |h| h[:date] }
      expect(dates).not_to include(Date.new(2025, 4, 1))
    end
  end
end

