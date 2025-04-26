require 'rails_helper'

RSpec.describe Reference, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:group) }
    it { should validate_presence_of(:value) }
  end

  describe 'scopes' do
    it 'returns records in ascending ID order' do
      Reference.destroy_all

      r1 = Reference.create!(group: "X", value: "First", model: "TestModel")
      r2 = Reference.create!(group: "X", value: "Second", model: "TestModel")

      expect(Reference.ordered).to eq([r1, r2])
    end
  end
end
