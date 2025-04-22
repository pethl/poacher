require 'rails_helper'

RSpec.describe MilkQualityMonitor, type: :model do
  describe 'associations' do
    it { should belong_to(:makesheet).optional }
  end

  describe 'scopes' do
    it 'returns records in descending order of sample_date (test records only)' do
      m1 = FactoryBot.create(:milk_quality_monitor, sample_date: Date.new(2023, 1, 1))
      m2 = FactoryBot.create(:milk_quality_monitor, sample_date: Date.new(2023, 2, 1))

      result = MilkQualityMonitor.where(id: [m1.id, m2.id]).ordered.pluck(:sample_date)
      expect(result).to eq([m2.sample_date, m1.sample_date])
    end
  end
end
