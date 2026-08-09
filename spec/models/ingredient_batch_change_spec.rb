require 'rails_helper'

RSpec.describe IngredientBatchChange, type: :model do
  describe 'associations' do
    it { should belong_to(:makesheet) }
    it { should belong_to(:delivery_inspection) }

    it { should belong_to(:created_by).class_name('User').optional }
    it { should belong_to(:updated_by).class_name('User').optional }
  end

  describe 'valid factory' do
    it 'is valid with defaults' do
      expect(build(:ingredient_batch_change)).to be_valid
    end
  end
end
