require 'rails_helper'

RSpec.describe Turn, type: :model do
  describe 'associations' do
    it { should belong_to(:makesheet) }
  end

  describe 'validations' do
    subject { FactoryBot.build(:turn) }

    it { should validate_presence_of(:turn_date) }
    it { should validate_presence_of(:makesheet_id) }
  end

  describe '#date_and_grade' do
    it 'returns formatted turn_date with makesheet batch' do
      makesheet = FactoryBot.create(:makesheet, batch: "B101")
      turn = FactoryBot.build(:turn, turn_date: Date.new(2025, 4, 20), makesheet: makesheet)

      expect(turn.date_and_grade).to eq("Sun 20 Apr 2025 B101")
    end
  end

  describe 'scopes' do
    it 'orders turns by turn_date descending (test records only)' do
      t1 = FactoryBot.create(:turn, turn_date: Date.new(2023, 4, 20))
      t2 = FactoryBot.create(:turn, turn_date: Date.new(2023, 5, 20))

      result = Turn.where(id: [t1.id, t2.id]).ordered.pluck(:turn_date)
      expect(result).to eq([t2.turn_date, t1.turn_date])
    end
  end
end
