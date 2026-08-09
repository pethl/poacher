require 'rails_helper'

RSpec.describe PalletisedDistribution, type: :model do
  describe 'associations' do
    it { should belong_to(:user).optional }
    it { should belong_to(:created_by).class_name('User').optional }
    it { should belong_to(:updated_by).class_name('User').optional }
  end

  describe 'scopes' do
    it 'orders by date descending' do
      d1 = create(
        :palletised_distribution,
        date: Date.new(2024, 5, 1)
      )

      d2 = create(
        :palletised_distribution,
        date: Date.new(2024, 5, 10)
      )

      result = PalletisedDistribution
               .where(id: [d1.id, d2.id])
               .ordered

      expect(result).to eq([d2, d1])
    end
  end

  describe 'validations' do
    context 'when no fields are filled' do
      it 'does not save and adds an error' do
        distribution = PalletisedDistribution.new

        expect(distribution).to be_invalid
        expect(distribution.errors[:base]).to include(
          "No fields entered – nothing to save!"
        )
      end
    end

    context 'when fields are filled but date is blank' do
      it 'defaults date to today' do
        distribution = PalletisedDistribution.create(
          company_name: 'Acme Logistics'
        )

        expect(distribution).to be_persisted
        expect(distribution.date).to eq(Date.current)
      end
    end

    context 'when date is provided' do
      it 'retains the provided date' do
        custom_date = Date.new(2024, 6, 1)

        distribution = PalletisedDistribution.create(
          company_name: 'Acme Logistics',
          date: custom_date
        )

        expect(distribution).to be_persisted
        expect(distribution.date).to eq(custom_date)
      end
    end
  end
end