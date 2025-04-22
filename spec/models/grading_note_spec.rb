require 'rails_helper'

RSpec.describe GradingNote, type: :model do
  describe 'associations' do
    it { should belong_to(:makesheet) }
    it { should belong_to(:head_taster_staff).class_name("Staff").with_foreign_key("head_taster").optional }
    it { should belong_to(:assistant_taster_staff_1).class_name("Staff").with_foreign_key("assistant_taster_1").optional }
    it { should belong_to(:assistant_taster_staff_2).class_name("Staff").with_foreign_key("assistant_taster_2").optional }
  end

  describe 'validations' do
    subject { FactoryBot.build(:grading_note) }

    it { should validate_presence_of(:makesheet).with_message("Makesheet must be selected") }
    it { should validate_presence_of(:head_taster).with_message("Head Taster must be selected — someone has to lead the tasting!") }
  end

  describe 'scopes' do
    it 'orders grading notes by associated makesheet make_date DESC' do
      m1 = FactoryBot.create(:makesheet, make_date: Date.new(2023, 1, 1))
      m2 = FactoryBot.create(:makesheet, make_date: Date.new(2023, 2, 1))
      g1 = FactoryBot.create(:grading_note, makesheet: m1, head_taster: FactoryBot.create(:staff).id)
      g2 = FactoryBot.create(:grading_note, makesheet: m2, head_taster: FactoryBot.create(:staff).id)

      expect(GradingNote.ordered_by_makesheet_date).to eq([g2, g1])
    end
  end
end
