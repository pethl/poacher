# spec/models/staff_spec.rb
require 'rails_helper'

RSpec.describe Staff, type: :model do
  describe 'associations' do
    it { should have_many(:chillers) }
    it { should have_many(:breakages) }
  
    it { should have_many(:cheese_makes).class_name('Makesheet').with_foreign_key('cheese_made_by_staff_id') }
    it { should have_many(:assists).class_name('Makesheet').with_foreign_key('assistant_staff_id') }
  end

  describe 'validations' do
    it { should validate_presence_of(:employment_status) }

    it do
      should validate_presence_of(:first_name)
        .with_message("First name is required")
    end

    it do
      should validate_presence_of(:last_name)
        .with_message("Last name is required")
    end
  end

  describe 'scopes' do
    it 'returns staff ordered by last name asc' do
      Staff.destroy_all # isolate the test
  
      s1 = described_class.create!(first_name: "Amy", last_name: "Zebra", employment_status: "Active")
      s2 = described_class.create!(first_name: "Ben", last_name: "Apple", employment_status: "Active")
  
      expect(Staff.ordered).to eq([s2, s1])
    end
  end
  

  describe '#full_name' do
    it 'returns the full name' do
      staff = described_class.new(first_name: "Jane", last_name: "Doe")
      expect(staff.full_name).to eq("Jane Doe")
    end
  end

  describe '#initials' do
    it 'returns the initials' do
      staff = described_class.new(first_name: "Jane", last_name: "Doe")
      expect(staff.initials).to eq("J. D")
    end
  end
end

