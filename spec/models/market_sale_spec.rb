require 'rails_helper'

RSpec.describe MarketSale, type: :model do
    describe "validations" do
    it "requires a market" do
      sale = build(:market_sale, market: nil)

      expect(sale).not_to be_valid
      expect(sale.errors[:market]).to include("Market must be entered.")
    end

    it "requires a sale date" do
      sale = build(:market_sale, sale_date: nil)

      expect(sale).not_to be_valid
      expect(sale.errors[:sale_date]).to include("Sale Date must be entered.")
    end

    it "requires total sales" do
      sale = build(:market_sale, total_sales: nil)

      expect(sale).not_to be_valid
      expect(sale.errors[:total_sales]).to include("Total sales must be entered.")
    end

    it "requires total sales to be numeric" do
      sale = build(:market_sale, total_sales: "abc")

      expect(sale).not_to be_valid
      expect(sale.errors[:total_sales]).to include("Total sales must be a valid number.")
    end
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
    it 'returns sales grouped by market and month for a given year' do
      FactoryBot.create(:market_sale, market: "Alby", sale_date: Date.new(2023, 1, 15), total_sales: 100.0)
      FactoryBot.create(:market_sale, market: "Alby", sale_date: Date.new(2023, 1, 20), total_sales: 50.0)
      FactoryBot.create(:market_sale, market: "Zelda", sale_date: Date.new(2023, 2, 1), total_sales: 80.0)

      result = MarketSale.sales_by_market_and_month(2023)

      expect(result.map(&:market)).to match_array(["Alby", "Zelda"])
      expect(result.map(&:total_sales)).to include(150.0, 80.0)
    end
  end
end
