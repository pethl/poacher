require 'rails_helper'

RSpec.describe ButterMake, type: :model do
  describe 'validations' do
    subject { FactoryBot.create(:butter_make, date: Date.today) }

    it { should validate_presence_of(:date) }
    it { should validate_uniqueness_of(:date) }
  end

  describe 'scopes' do
    it 'orders butter makes by ascending date' do
      b1 = FactoryBot.create(:butter_make, date: Date.today - 1)
      b2 = FactoryBot.create(:butter_make, date: Date.today)

      expect(ButterMake.ordered).to eq([b1, b2])
    end
  end

  describe '#stock_calc' do
    context 'when yesterday exists' do
      it 'calculates stock correctly' do
        FactoryBot.create(:butter_make, date: Date.today - 1, stock: 5)
        today_make = FactoryBot.create(:butter_make, date: Date.today, cream: 3, make: 2)

        expect(today_make.stock_calc).to eq(6) # 5 (yesterday) + 3 - 2
      end
    end

    context 'when yesterday is missing' do
      it 'defaults yesterdays stock to 2' do
        today_make = FactoryBot.create(:butter_make, date: Date.today, cream: 4, make: 1)

        expect(today_make.stock_calc).to eq(5) # 2 (default) + 4 - 1
      end
    end

    context 'when cream or make is nil' do
      it 'returns nil for incomplete data' do
        FactoryBot.create(:butter_make, date: Date.today - 1, stock: 5)
        incomplete = FactoryBot.create(:butter_make, date: Date.today, cream: nil, make: 3)

        expect(incomplete.stock_calc).to be_nil
      end
    end
  end
end
