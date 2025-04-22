require 'rails_helper'

RSpec.describe MarketSale, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:market) }
    it { should validate_presence_of(:sale_date) }
  end

  describe 'scopes' do
    it 'orders by sale_date then market (A-Z)' do
      s1 = FactoryBot.create(:market_sale, sale_date: Date.new(2023, 4, 1), market: "Z Market")
      s2 = FactoryBot.create(:market_sale, sale_date: Date.new(2023, 4, 1), market: "A Market")
      s3 = FactoryBot.create(:market_sale, sale_date: Date.new(2023, 3, 1), market: "B Market")

      result = MarketSale.where(id: [s1.id, s2.id, s3.id]).sorted_by_date_and_market

      expect(result).to eq([s3, s2, s1])
    end
  end

  describe '.sales_by_market_and_month' do
    it 'returns sales grouped by market and month for 2023' do
      FactoryBot.create(:market_sale, market: "Alby", sale_date: Date.new(2023, 1, 15), total_sales: 100.0)
      FactoryBot.create(:market_sale, market: "Alby", sale_date: Date.new(2023, 1, 20), total_sales: 50.0)
      FactoryBot.create(:market_sale, market: "Zelda", sale_date: Date.new(2023, 2, 1), total_sales: 80.0)

      result = MarketSale.sales_by_market_and_month

      expect(result.map(&:market)).to match_array(["Alby", "Zelda"])
      expect(result.map(&:total_sales)).to include(150.0, 80.0)
    end
  end
end
