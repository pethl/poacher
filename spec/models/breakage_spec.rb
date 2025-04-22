# spec/models/breakage_spec.rb
require 'rails_helper'

RSpec.describe Breakage, type: :model do
  describe 'associations' do
    it { should belong_to(:staff).optional }
  end

  describe 'scopes' do
    before do
      Breakage.destroy_all
    end

    describe '.ordered' do
      it 'returns breakages in ascending date order' do
        b1 = Breakage.create!(date: Date.new(2024, 12, 1))
        b2 = Breakage.create!(date: Date.new(2024, 11, 1))
        expect(Breakage.ordered).to eq([b2, b1])
      end
    end

    describe '.filter_by_month_and_year' do
      it 'returns breakages from the specified month and year' do
        match = Breakage.create!(date: Date.new(2024, 12, 15))
        Breakage.create!(date: Date.new(2023, 12, 15)) # wrong year
        Breakage.create!(date: Date.new(2024, 11, 15)) # wrong month

        result = Breakage.filter_by_month_and_year(12, 2024)

        expect(result).to include(match)
        expect(result.size).to eq(1)
      end
    end
  end
end
