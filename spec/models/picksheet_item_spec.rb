# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PicksheetItem, type: :model do
  describe 'associations' do
    it { should belong_to(:picksheet) }
    it { should belong_to(:makesheet).optional }

    it { should belong_to(:created_by).class_name('User').optional }
    it { should belong_to(:updated_by).class_name('User').optional }
  end

  describe 'validations' do
    it 'requires a product when no makesheet is selected' do
      item = build(:picksheet_item, product: nil, makesheet: nil)

      item.validate
      expect(item.errors[:product]).to include("can't be blank")
    end

    it 'requires a makesheet when no product is selected' do
      item = build(:picksheet_item, product: nil, makesheet: nil)

      item.validate
      expect(item.errors[:makesheet_id]).to include("can't be blank")
    end
  end

  describe 'scopes' do
    it 'returns items in ascending id order' do
      item1 = create(:picksheet_item)
      item2 = create(:picksheet_item)

      expect(PicksheetItem.ordered).to eq([item1, item2])
    end
  end

  describe '#previous_id' do
    it 'returns the previous item on the same picksheet' do
      picksheet = create(:picksheet)

      item1 = create(:picksheet_item, picksheet: picksheet)
      item2 = create(:picksheet_item, picksheet: picksheet)

      expect(item2.previous_id).to eq(item1)
    end
  end

  describe '#display_product_or_grade' do
    it 'returns the product when no makesheet is attached' do
      item = build(:picksheet_item, product: 'Poacher')

      expect(item.display_product_or_grade).to eq('Poacher')
    end

    it 'returns grade and make date when linked to a makesheet' do
      makesheet = build_stubbed(
        :makesheet,
        grade: 'A',
        make_date: Date.new(2025, 5, 1)
      )

      item = build(
        :picksheet_item,
        product: nil,
        makesheet: makesheet
      )

      expect(item.display_product_or_grade)
        .to eq('A 01/05/25')
    end
  end

  describe '#get_weight' do
    it 'calculates the weight from the conversion table' do
      create(
        :calculation,
        product: 'Poacher',
        size: '1/3',
        weight: 2000
      )

      item = build(
        :picksheet_item,
        product: 'Poacher',
        size: '1/3',
        count: 3
      )

      expect(item.get_weight).to eq(6.0)
    end
  end
end