require 'rails_helper'

RSpec.describe PalletisedDistribution, type: :model do
  describe 'associations' do
    it { should belong_to(:staff).optional }
  end

  describe 'scopes' do
    it 'orders by date descending' do
      d1 = FactoryBot.create(:palletised_distribution, date: Date.new(2024, 5, 1))
      d2 = FactoryBot.create(:palletised_distribution, date: Date.new(2024, 5, 10))

      result = PalletisedDistribution.where(id: [d1.id, d2.id]).ordered

      expect(result).to eq([d2, d1])
    end
  end
end
