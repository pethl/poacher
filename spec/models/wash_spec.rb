require 'rails_helper'

RSpec.describe Wash, type: :model do
  describe 'associations' do
    it { should have_many(:wash_picksheets) }
    it { should have_many(:picksheets).through(:wash_picksheets) }
  end

  describe 'scopes' do
    it 'returns records ordered by action_date ascending (test records only)' do
      w1 = FactoryBot.create(:wash, action_date: Date.new(2024, 3, 1))
      w2 = FactoryBot.create(:wash, action_date: Date.new(2024, 3, 2))

      result = Wash.where(id: [w1.id, w2.id]).ordered.pluck(:action_date)
      expect(result).to eq([w1.action_date, w2.action_date])
    end
  end
end
