# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Makesheet, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:turns) }
    it { is_expected.to have_many(:traceability_records) }
    it { is_expected.to have_many(:batch_weights) }
    it { is_expected.to have_many(:ingredient_batch_changes).dependent(:destroy) }
    it { is_expected.to have_many(:delivery_inspections).through(:ingredient_batch_changes) }
    it { is_expected.to have_and_belong_to_many(:samples) }
    it { is_expected.to have_one(:grading_note).dependent(:destroy) }

    it { is_expected.to belong_to(:pre_start_inspection_by_staff).class_name('Staff').with_foreign_key('pre_start_inspection_by_staff_id').optional }
    it { is_expected.to belong_to(:pre_start_inspection_by_2_staff).class_name('Staff').with_foreign_key('pre_start_inspection_by_2_staff_id').optional }
    it { is_expected.to belong_to(:cheese_made_by_staff).class_name('Staff').with_foreign_key('cheese_made_by_staff_id').optional }
    it { is_expected.to belong_to(:contact).optional }
    it { is_expected.to belong_to(:location).optional }
  end

  describe 'validations' do
    subject { build(:makesheet) } # for uniqueness matcher

    it { is_expected.to validate_presence_of(:make_date) }
    it do
      expect(subject).to validate_uniqueness_of(:make_date)
        .with_message("This date has already been taken. There cannot be two makesheets with the same date.")
    end

    it do
      expect(subject).to validate_presence_of(:make_type)
        .with_message("must be selected – please choose a make type.")
    end
  end

  describe 'scopes' do# ordered: ascending by make_date
    it 'ordered: ascending by make_date (test records only)' do
      d1 = Date.today + 10_000 # safely away from fixtures
      d2 = d1 + 1
      m1 = create(:makesheet, make_date: d1)
      m2 = create(:makesheet, make_date: d2)
      expect(Makesheet.where(id: [m1.id, m2.id]).ordered.pluck(:make_date))
        .to eq([d1, d2])
    end
    
    # ordered_reverse: descending by make_date
    it 'ordered_reverse: descending by make_date (test records only)' do
      d1 = Date.today + 20_000
      d2 = d1 + 1
      m1 = create(:makesheet, make_date: d1)
      m2 = create(:makesheet, make_date: d2)
      expect(Makesheet.where(id: [m1.id, m2.id]).ordered_reverse.pluck(:make_date))
        .to eq([d2, d1])
    end

    it 'not_finished excludes status = "Finished"' do
      a = create(:makesheet, status: 'Created')
      b = create(:makesheet, status: 'Finished')
      ids = Makesheet.where(id: [a.id, b.id]).not_finished.pluck(:id)
      expect(ids).to contain_exactly(a.id)
    end

   # filter_by_month_and_year
it 'filter_by_month_and_year filters correctly' do
  base = Date.today + 30_000
  jan  = create(:makesheet, make_date: Date.new(base.year, 1, 15))
  feb  = create(:makesheet, make_date: Date.new(base.year, 2, 1))
  ids = Makesheet.filter_by_month_and_year(1, base.year).pluck(:id)
  expect(ids).to include(jan.id)
  expect(ids).not_to include(feb.id)
end
  end

  describe '#progress' do
    it 'returns "N" if no data' do
      makesheet = build(:makesheet, make_type: nil, milk_used: nil)
      expect(makesheet.progress).to eq('N')
    end

    it 'returns "I" when only type and milk used are set' do
      makesheet = build(:makesheet, :with_I)
      expect(makesheet.progress).to eq('I')
    end

    it 'returns "II" when cut times are added' do
      makesheet = build(:makesheet, :with_I, :with_II,
                        total_weight: nil,
                        number_of_cheeses: nil,
                        pre_start_inspection_by_staff: nil)
      expect(makesheet.progress).to eq('II')
    end
    

    it 'returns "III" when weight and cheese count are present' do
      makesheet = build(:makesheet, :with_I, :with_II, :with_III)
      expect(makesheet.progress).to eq('III')
    end

    it 'returns "IV" when all required fields are set' do
      makesheet = create(
        :makesheet, :with_I, :with_II, :with_III, :with_IV,
        qty_of_starter_used: 10.0 # meet ValidationRange minimum
      )
      expect(makesheet.progress).to eq('IV')
    end
  end

  describe '#yield' do
    it 'is 0 when milk_used is 0/nil' do
      expect(build(:makesheet, total_weight: 100, milk_used: 0).yield).to eq(0)
    end

    it 'calculates yield as percent' do
      m = build(:makesheet, total_weight: 100, milk_used: 400)
      expect(m.yield.round(2)).to eq(25.0)
    end
  end

  describe '#age_in_days' do
    it 'returns days since make_date' do
      m = build(:makesheet, make_date: Date.today - 10)
      expect(m.age_in_days).to eq(10)
    end
  end

  describe '#batch_and_grade' do
    it 'returns formatted date and batch (grade no longer included)' do
      m = build(:makesheet, make_date: Date.new(2025, 9, 16), batch: 'B123', grade: 'A')
      # 16-Sep format per model
      expect(m.batch_and_grade).to eq('16-Sep [B123]')
    end
  end
end

