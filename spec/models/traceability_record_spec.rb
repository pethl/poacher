require 'rails_helper'

RSpec.describe TraceabilityRecord, type: :model do
  describe 'associations' do
    it { should belong_to(:makesheet).optional }
    it { should have_many(:waste_records).dependent(:destroy) }
  end

  describe 'validations' do
    subject { FactoryBot.build(:traceability_record) }

    it { should validate_presence_of(:makesheet_id).with_message("Please select a Makesheet") }
    it { should validate_uniqueness_of(:makesheet_id).with_message("This Makesheet has already been used for another record") }
    it { should validate_presence_of(:date_started_batch).with_message("Start date is required") }

    (1..35).each do |i|
      it "validates individual_cheese_weight_#{i} is a number >= 0 and < 100" do
        record = FactoryBot.build(:traceability_record, :"individual_cheese_weight_#{i}" => 101)
        expect(record).to be_invalid
        expect(record.errors[:"individual_cheese_weight_#{i}"]).to include("Cheese weight must be a number between 0 and 99.99")
      end
    end
  end

  describe 'scopes' do
    it 'orders by date_started_batch ascending' do
      r1 = FactoryBot.create(:traceability_record, date_started_batch: Date.new(2024, 4, 1))
      r2 = FactoryBot.create(:traceability_record, date_started_batch: Date.new(2024, 4, 2))
      expect(TraceabilityRecord.where(id: [r1.id, r2.id]).ordered).to eq([r1, r2])
    end
  end

  describe '#calculated_batch_cheese_count' do
    it 'counts the number of non-nil cheese weight fields' do
      record = FactoryBot.build(:traceability_record,
        individual_cheese_weight_1: 1.2,
        individual_cheese_weight_2: 0.9,
        individual_cheese_weight_3: nil
      )
      expect(record.calculated_batch_cheese_count).to eq(2)
    end
  end

  describe '#calculated_batch_cheese_weight_total' do
    it 'totals all present cheese weights' do
      record = FactoryBot.build(:traceability_record,
        individual_cheese_weight_1: 2.0,
        individual_cheese_weight_2: 3.5,
        individual_cheese_weight_3: nil
      )
      expect(record.calculated_batch_cheese_weight_total).to eq(5.5)
    end
  end

  describe 'waste record sums' do
    let(:traceability_record) { FactoryBot.create(:traceability_record) }

    before do
      FactoryBot.create(:waste_record, traceability_record: traceability_record, waste_date: Date.today, wedges: 1.0, cooking: 2.0, blue: 0.5, t_and_bs: 0.3, waste: 0.7)
      FactoryBot.create(:waste_record, traceability_record: traceability_record, waste_date: Date.today + 1, wedges: 1.5, cooking: 1.0, blue: 1.5, t_and_bs: 0.7, waste: 1.3)
    end

  

    it 'totals waste wedges' do
      expect(traceability_record.waste_records_total_wedges).to eq(2.5)
    end

    it 'totals cooking waste' do
      expect(traceability_record.waste_records_total_cooking).to eq(3.0)
    end

    it 'totals blue waste' do
      expect(traceability_record.waste_records_total_blue).to eq(2.0)
    end

    it 'totals t_and_bs' do
      expect(traceability_record.waste_records_t_and_bs).to eq(1.0)
    end

    it 'totals general waste' do
      expect(traceability_record.waste_records_waste).to eq(2.0)
    end
  end
end
