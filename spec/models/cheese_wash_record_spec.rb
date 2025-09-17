require 'rails_helper'

RSpec.describe CheeseWashRecord, type: :model do
  describe 'associations' do
    it { should belong_to(:makesheet).optional }
    it { should belong_to(:created_by).class_name('User').optional }
    it { should belong_to(:updated_by).class_name('User').optional }
  end

  describe 'validations' do
    it 'requires makesheet_id with custom message' do
      rec = build(:cheese_wash_record, makesheet: nil)
      expect(rec).to be_invalid
      expect(rec.errors[:makesheet_id]).to include("Makesheet must be selected before saving the wash record.")
    end

    it 'enforces uniqueness of makesheet_id with custom message' do
      m = create(:makesheet, :recent, number_of_cheeses: 30)
      create(:cheese_wash_record, makesheet: m)
      dup = build(:cheese_wash_record, makesheet: m)
      expect(dup).to be_invalid
      expect(dup.errors[:makesheet_id]).to include("This batch already has a wash record.")
    end
  end

  describe 'scopes' do
    it 'orders ascending by date_batch_started' do
      r1 = create(:cheese_wash_record, date_batch_started: Date.new(2025, 1, 10))
      r2 = create(:cheese_wash_record, date_batch_started: Date.new(2025, 1, 12))
      expect(CheeseWashRecord.where(id: [r1.id, r2.id]).ordered).to eq([r1, r2])
    end
  end

  describe '#total_washed' do
    it 'sums number_washed_1..24 (nil treated as 0)' do
      rec = build(:cheese_wash_record, number_washed_1: 5, number_washed_2: 7, number_washed_10: 3)
      expect(rec.total_washed).to eq(15)
    end
  end

  describe '#wash_date_range' do
    it 'returns min..max over present wash dates, or nil if none' do
      rec = build(:cheese_wash_record,
                  wash_date_1: Date.new(2025, 2, 1),
                  wash_date_3: Date.new(2025, 2, 3),
                  wash_date_2: Date.new(2025, 2, 2))
      expect(rec.wash_date_range).to eq(Date.new(2025, 2, 1)..Date.new(2025, 2, 3))
      blank = build(:cheese_wash_record)
      expect(blank.wash_date_range).to be_nil
    end
  end

  describe '#remaining_to_wash' do
    it 'is makesheet.number_of_cheeses - total_washed' do
      m = create(:makesheet, number_of_cheeses: 30)
      rec = build(:cheese_wash_record, makesheet: m, number_washed_1: 12, number_washed_2: 5)
      expect(rec.remaining_to_wash).to eq(13)
    end
  end

  describe 'cannot finish until fully washed' do
    it "adds an error when finished but not fully washed" do
      m = create(:makesheet, number_of_cheeses: 30)
      rec = build(:cheese_wash_record, :partial, makesheet: m, date_batch_finished: Date.today)
      expect(rec).to be_invalid
      expect(rec.errors[:date_batch_finished]).to include("Cheeses remaining, please check count - can't set Finish Date")
    end

    it 'is valid when fully washed' do
      m = create(:makesheet, number_of_cheeses: 30)
      # fully washed across fields; finished date set
      rec = build(:cheese_wash_record, :finished, makesheet: m)
      expect(rec.total_washed).to eq(30)
      expect(rec).to be_valid
    end
  end
end
