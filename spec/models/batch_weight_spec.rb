require 'rails_helper'

RSpec.describe BatchWeight, type: :model do
  describe 'associations' do
    it { should belong_to(:makesheet) }
  end

  describe 'validations' do
    subject { FactoryBot.create(:batch_weight) }
  
    it { should validate_presence_of(:makesheet_id) }
    it { should validate_uniqueness_of(:makesheet_id) }
    it { should validate_presence_of(:date) }
  end

  describe 'scopes' do
    it 'returns records in ascending date order' do
      # Clear existing test data because this project retains
      # reference records in the test database.
      BatchWeight.destroy_all

      b1 = BatchWeight.create!(makesheet: FactoryBot.create(:makesheet), date: Date.today - 2)
      b2 = BatchWeight.create!(makesheet: FactoryBot.create(:makesheet), date: Date.today)

      expect(BatchWeight.ordered).to eq([b1, b2])
    end


    it 'excludes all records because the callback marks them as finished' do
      BatchWeight.destroy_all
    
      m1 = FactoryBot.create(:makesheet, status: "Grading")
      m2 = FactoryBot.create(:makesheet, status: "Grading")  # even if both start as Grading
      b1 = BatchWeight.create!(makesheet: m1, date: Date.today)
      b2 = BatchWeight.create!(makesheet: m2, date: Date.today + 1)
    
      # Because the callback fires, both associated makesheets become "Finished"
      expect(BatchWeight.not_finished).to be_empty
    end

  end

  describe 'callbacks' do
    it 'sets makesheet status to Finished after creation' do
      makesheet = FactoryBot.create(:makesheet, status: "Grading")
      BatchWeight.create!(makesheet: makesheet, date: Date.today)

      expect(makesheet.reload.status).to eq("Finished")
    end
  end

  describe '#weight_minus_waste' do
    it 'subtracts total waste from the washed batch weight' do
      batch_weight = build(
        :batch_weight,
        washed_batch_weight: 350.5,
        total_waste: 12.25
      )

      expect(batch_weight.weight_minus_waste).to eq(338.25)
    end
  end

  describe '#waste_percentage' do
    it 'calculates waste as a percentage of washed batch weight' do
      batch_weight = build(
        :batch_weight,
        washed_batch_weight: 400,
        total_waste: 20
      )

      expect(batch_weight.waste_percentage).to eq(5.0)
    end

    it 'returns zero when washed batch weight is zero' do
      batch_weight = build(
        :batch_weight,
        washed_batch_weight: 0,
        total_waste: 20
      )

      expect(batch_weight.waste_percentage).to eq(0.0)
    end

    it 'returns zero when total waste is zero' do
      batch_weight = build(
        :batch_weight,
        washed_batch_weight: 400,
        total_waste: 0
      )

      expect(batch_weight.waste_percentage).to eq(0.0)
    end
  end


  describe '.waste_trend' do
    it 'filters by BatchWeight date and the linked makesheet make type' do
      standard = create(:batch_weight,
                        date: Date.new(2025, 4, 10),
                        makesheet: create(:makesheet, make_type: 'Standard'))
      create(:batch_weight,
             date: Date.new(2025, 4, 11),
             makesheet: create(:makesheet, make_type: 'Red'))
      create(:batch_weight,
             date: Date.new(2024, 4, 10),
             makesheet: create(:makesheet, make_type: 'Standard'))

      result = described_class.waste_trend(
        start_date: Date.new(2025, 4, 1),
        end_date: Date.new(2025, 4, 30),
        make_type: 'Standard'
      )

      expect(result).to contain_exactly(standard)
    end

    it 'excludes records whose waste percentage cannot be calculated' do
      create(:batch_weight, washed_batch_weight: 0, total_waste: 10)
      usable = create(:batch_weight, washed_batch_weight: 100, total_waste: 2)

      result = described_class.waste_trend(
        start_date: Date.yesterday,
        end_date: Date.tomorrow
      )

      expect(result).to contain_exactly(usable)
    end
  end
end
