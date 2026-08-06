require 'rails_helper'

RSpec.describe Calculation, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:product) }
    it { should validate_presence_of(:size) }
    it { should validate_presence_of(:weight) }
    it { should validate_uniqueness_of(:size).scoped_to(:product) }
  end

  describe 'scopes' do
    it 'orders by product ASC, then weight DESC (test records only)' do
     c1 = FactoryBot.create(:calculation, product: "Poacher", size: "Large", weight: 30)
      c2 = FactoryBot.create(:calculation, product: "Poacher", size: "Small", weight: 20)
      c3 = FactoryBot.create(:calculation, product: "P50", weight: 15)
  
      result_ids = Calculation.where(id: [c1.id, c2.id, c3.id]).ordered.pluck(:id)
      expected_order = [c3.id, c1.id, c2.id] # because: P50 < Vintage < Poacher
  
      expect(result_ids).to eq(expected_order)
    end
  end
  
end
