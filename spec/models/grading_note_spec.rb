require 'rails_helper'

RSpec.describe GradingNote, type: :model do
  describe 'associations' do
    it { should belong_to(:makesheet) }

    
  end

  describe 'validations' do
    subject { FactoryBot.build(:grading_note) }

    it { should validate_presence_of(:makesheet).with_message("Makesheet must be selected") }

   it do
      should belong_to(:head_taster)
        .class_name("User")
    end
  end

  describe 'scopes' do
    it 'orders grading notes by associated makesheet make_date DESC' do
      m1 = FactoryBot.create(:makesheet, make_date: Date.new(2023, 1, 1))
      m2 = FactoryBot.create(:makesheet, make_date: Date.new(2023, 2, 1))

      g1 = FactoryBot.create(
        :grading_note,
        makesheet: m1,
        head_taster: FactoryBot.create(:user)
      )

      g2 = FactoryBot.create(
        :grading_note,
        makesheet: m2,
        head_taster: FactoryBot.create(:user)
      )

      expect(GradingNote.ordered_by_makesheet_date).to eq([g2, g1])
    end
  end
end