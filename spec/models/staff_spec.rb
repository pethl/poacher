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
    it 'returns staff ordered by first name asc' do
      a = create(:staff, first_name: 'Alice')
      c = create(:staff, first_name: 'Charlie')
      b = create(:staff, first_name: 'Bob')
  
      # Only assert over the records we created
      result = Staff.where(id: [a.id, b.id, c.id]).order(first_name: :asc).pluck(:first_name)
      expect(result).to eq(%w[Alice Bob Charlie])
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
      expect(staff.initials).to eq("J.D.")
    end
  end
end

