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

  describe 'validations' do
    context 'when no fields are filled' do
      it 'does not save and adds an error' do
        distribution = PalletisedDistribution.new

        expect(distribution.valid?).to be false
        expect(distribution.errors[:base]).to include("No fields entered – nothing to save!")
      end
    end

    context 'when fields are filled but date is blank' do
      it 'defaults date to today' do
        distribution = PalletisedDistribution.create(company_name: 'Acme Logistics')

        expect(distribution.persisted?).to be true
        expect(distribution.date).to eq(Date.today)
      end
    end

    context 'when date is provided' do
      it 'retains the provided date' do
        custom_date = Date.new(2024, 6, 1)
        distribution = PalletisedDistribution.create(company_name: 'Acme Logistics', date: custom_date)

        expect(distribution.persisted?).to be true
        expect(distribution.date).to eq(custom_date)
      end
    end
  end
end
