require 'rails_helper'

RSpec.describe Sample, type: :model do
  describe 'associations' do
    it { should have_and_belong_to_many(:makesheets) }
  end

  describe 'validations' do
    subject { FactoryBot.build(:sample) } # Needed for uniqueness
    it { should validate_uniqueness_of(:sample_no) }
  end 

  describe 'scopes' do
    it 'orders by sample_no ascending (test records only)' do
      s1 = FactoryBot.create(:sample, sample_no: "Z100")
      s2 = FactoryBot.create(:sample, sample_no: "A001")

      result = Sample.where(id: [s1.id, s2.id]).ordered.pluck(:sample_no)
      expect(result).to eq([s2.sample_no, s1.sample_no])
    end
  end
end
