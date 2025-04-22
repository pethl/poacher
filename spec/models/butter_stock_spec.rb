# spec/models/butter_stock_spec.rb
require 'rails_helper'

RSpec.describe ButterStock, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:make_date) }
  end

  describe 'scopes' do
    it 'orders butter stocks by make_date ascending' do
      b1 = FactoryBot.create(:butter_stock, make_date: Date.today - 2)
      b2 = FactoryBot.create(:butter_stock, make_date: Date.today)

      expect(ButterStock.ordered).to eq([b1, b2])
    end
  end
end
