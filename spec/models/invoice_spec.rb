require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:number) }
    it { should validate_presence_of(:date) }
  end

  describe 'scopes' do
    it 'orders invoices by number ascending' do
      i1 = FactoryBot.create(:invoice, number: 1002)
      i2 = FactoryBot.create(:invoice, number: 1001)

      expect(Invoice.ordered.pluck(:number)).to eq([1001, 1002])
    end
  end
end