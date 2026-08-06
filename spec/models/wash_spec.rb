require 'rails_helper'

RSpec.describe Wash, type: :model do
  describe 'associations' do
    it { should have_many(:wash_picksheets).dependent(:restrict_with_error) }
    it { should have_many(:picksheets).through(:wash_picksheets) }

    it do
      should belong_to(:created_by)
        .class_name('User')
        .optional
    end

    it do
      should belong_to(:updated_by)
        .class_name('User')
        .optional
    end
  end

  describe 'validations' do
      subject { build(:wash, action_date: Date.current, wash_status: 'Created') }

      it { should validate_presence_of(:action_date) }
      it { should validate_presence_of(:wash_status) }
    end

  describe 'scopes' do
    it 'returns records ordered by action_date ascending' do
      w1 = create(:wash, action_date: Date.new(2024, 3, 1))
      w2 = create(:wash, action_date: Date.new(2024, 3, 2))

      result = described_class
               .where(id: [w1.id, w2.id])
               .ordered
               .pluck(:action_date)

      expect(result).to eq([w1.action_date, w2.action_date])
    end
  end
end