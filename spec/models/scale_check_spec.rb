require 'rails_helper'

RSpec.describe ScaleCheck, type: :model do
  describe 'associations' do
    it { should belong_to(:staff).optional }
  end

  describe 'validations' do
    subject { FactoryBot.create(:scale_check) } 
    # Needed for uniqueness validation (create, not build)

    it { should validate_presence_of(:scale_name) }
    it { should validate_presence_of(:check_date) }
    it { should validate_presence_of(:frequency) }

    it {
      should validate_uniqueness_of(:check_date)
        .scoped_to(:scale_name, :frequency)
        .with_message("Already have a record for this scale and date.")
    }

    it 'validates presence of staff_id with custom message' do
      scale_check = FactoryBot.build(:scale_check, staff_id: nil)
      scale_check.validate
      expect(scale_check.errors[:staff_id]).to include("Please identify yourself from the Staff list.")
    end
  end
end

