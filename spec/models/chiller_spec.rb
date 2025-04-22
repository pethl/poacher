require 'rails_helper'

RSpec.describe Chiller, type: :model do
  describe 'associations' do
    it { should belong_to(:staff).optional }
  end

  describe 'scopes' do
    before { Chiller.destroy_all }

    it 'orders chillers by ascending date' do
      c1 = FactoryBot.create(:chiller, date: Date.new(2023, 1, 1))
      c2 = FactoryBot.create(:chiller, date: Date.new(2023, 1, 2))
      expect(Chiller.ordered).to eq([c1, c2])
    end

    it 'filters chillers by month and year' do
      match = FactoryBot.create(:chiller, date: Date.new(2024, 12, 15))
      FactoryBot.create(:chiller, date: Date.new(2024, 11, 15))
      FactoryBot.create(:chiller, date: Date.new(2023, 12, 15))

      result = Chiller.filter_by_month_and_year(12, 2024)
      expect(result).to include(match)
      expect(result.size).to eq(1)
    end
  end

  describe 'custom validation on update' do
    it 'adds errors if fields are missing when edited' do
      chiller = FactoryBot.create(:chiller, chiller_1: nil, chiller_2: nil, staff: nil, signature: nil)
      
      chiller.chiller_1 = nil
      expect(chiller.valid?).to be false

      expect(chiller.errors[:base]).to include("Chiller 1 is required")
      expect(chiller.errors[:base]).to include("Chiller 2 is required")
      expect(chiller.errors[:base]).to include("Staff must be selected")
      expect(chiller.errors[:base]).to include("Signature is required")
    end

    it 'does not run validation on create' do
      chiller = FactoryBot.build(:chiller, chiller_1: nil, chiller_2: nil, staff: nil, signature: nil)
      expect(chiller.save).to be true
    end
  end
end
