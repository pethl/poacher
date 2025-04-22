require 'rails_helper'

RSpec.describe Makesheet, type: :model do
  describe 'associations' do
    it { should have_many(:turns) }
    it { should have_many(:traceability_records) }
    it { should have_many(:batch_weights) }
    it { should have_many(:samples) }
   
    it { should have_one(:grading_note).dependent(:destroy) }

    it { should belong_to(:pre_start_inspection_by_staff).class_name("Staff").with_foreign_key("pre_start_inspection_by_staff_id").optional }
    it { should belong_to(:cheese_made_by_staff).class_name("Staff").with_foreign_key("cheese_made_by_staff_id").optional }
    it { should belong_to(:contact).optional }
  end

  describe 'validations' do
    subject { FactoryBot.build(:makesheet) }  # needed for uniqueness_of

    it { should validate_presence_of(:make_date) }
    it { should validate_uniqueness_of(:make_date).with_message("has already been taken. There cannot be two makesheets with the same date.") }
    it { should validate_presence_of(:make_type) }
  end

  describe 'scopes' do
    let(:unique_today) { Date.today + rand(1000) }

    it 'returns in ascending date order (test records only)' do
      m1 = FactoryBot.create(:makesheet, make_date: Date.new(2026, 11, 21))
      m2 = FactoryBot.create(:makesheet, make_date: Date.new(2026, 11, 22))
    
      result = Makesheet.where(id: [m1.id, m2.id]).ordered.pluck(:make_date)
    
      expect(result).to eq([m1.make_date, m2.make_date])
    end

    

    it 'returns in descending date order (test records only)' do
      m1 = FactoryBot.create(:makesheet, make_date: Date.new(2025, 5, 19))
      m2 = FactoryBot.create(:makesheet, make_date: Date.new(2025, 5, 20))
    
      result = Makesheet.where(id: [m1.id, m2.id]).ordered_reverse.pluck(:make_date)
    
      expect(result).to eq([m2.make_date, m1.make_date])
    end
  end

  describe '#progress' do
    it 'returns "N" if no data' do
      makesheet = FactoryBot.build(:makesheet, make_type: nil, milk_used: nil)
      expect(makesheet.progress).to eq("N")
    end

    it 'returns "I" when only type and milk used are set' do
      makesheet = FactoryBot.build(:makesheet, make_type: "Standard", milk_used: 100)
      expect(makesheet.progress).to eq("I")
    end

    it 'returns "II" when cut times are added' do
      makesheet = FactoryBot.build(
        :makesheet,
        make_type: "Standard",
        milk_used: 100,
        first_cut_time: Time.now,
        second_cut_time: Time.now,
        total_weight: nil,
        number_of_cheeses: nil,
        pre_start_inspection_by_staff_id: nil
      )
    
      expect(makesheet.progress).to eq("II")
    end

    it 'returns "III" when weight and cheese count are present' do
      makesheet = FactoryBot.build(:makesheet, make_type: "Standard", milk_used: 100, first_cut_time: Time.now, second_cut_time: Time.now, total_weight: 40.0, number_of_cheeses: 20)
      expect(makesheet.progress).to eq("III")
    end

    it 'returns "IV" when all required fields are set' do
      staff = FactoryBot.create(:staff)
      makesheet = FactoryBot.build(:makesheet, make_type: "Standard", milk_used: 100, first_cut_time: Time.now, second_cut_time: Time.now, total_weight: 40.0, number_of_cheeses: 20, pre_start_inspection_by_staff_id: staff.id)
      expect(makesheet.progress).to eq("IV")
    end
  end

  describe '#yield' do
    it 'calculates yield as percent' do
      m = FactoryBot.build(:makesheet, total_weight: 100, milk_used: 400)
      expect(m.yield.round(2)).to eq(25.0)
    end
  end

  describe '#age_in_days' do
    it 'returns days since make_date' do
      m = FactoryBot.build(:makesheet, make_date: Date.today - 10)
      expect(m.age_in_days).to eq(10)
    end
  end

  describe '#batch_and_grade' do
    it 'returns batch and grade string if both present' do
      m = FactoryBot.build(:makesheet, batch: "B123", grade: "A")
      expect(m.batch_and_grade).to eq("B123 A")
    end

    it 'returns just batch if grade missing' do
      m = FactoryBot.build(:makesheet, batch: "B123", grade: nil)
      expect(m.batch_and_grade).to eq("B123")
    end
  end
end
