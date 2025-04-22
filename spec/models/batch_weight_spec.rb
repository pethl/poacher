require 'rails_helper'

RSpec.describe BatchWeight, type: :model do
  describe 'associations' do
    it { should belong_to(:makesheet).optional }
  end

  describe 'validations' do
    subject { FactoryBot.create(:batch_weight) }
  
    it { should validate_presence_of(:makesheet_id) }
    it { should validate_uniqueness_of(:makesheet_id) }
    it { should validate_presence_of(:date) }
  end

  describe 'scopes' do
    it 'returns records in ascending date order' do
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
end
