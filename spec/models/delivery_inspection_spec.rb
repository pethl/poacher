# spec/models/delivery_inspection_spec.rb
require 'rails_helper'

RSpec.describe DeliveryInspection, type: :model do
  let(:item) { 'Rennet - Vegetable' }

  # Tiny helper to keep builds consistent
  def create_di(date:, item: 'Rennet - Vegetable', attrs: {})
    create(:delivery_inspection, { delivery_date: date, item: item }.merge(attrs))
  end

  describe 'associations' do
    it { should belong_to(:staff) }

    it do
      should have_many(:ingredient_batch_changes)
        .dependent(:restrict_with_error)
    end

    it { should have_many(:makesheets).through(:ingredient_batch_changes) }
  end

  describe 'validations' do
    subject { build(:delivery_inspection) }

    it do
      should validate_presence_of(:delivery_date)
        .with_message('Delivery date must be provided')
    end

    it do
      should validate_presence_of(:item)
        .with_message('Item must be selected')
    end

    it do
      should validate_presence_of(:batch_no)
        .with_message('Batch No. must be entered')
    end

    it do
      should validate_presence_of(:best_before)
        .with_message('Best before date must be entered')
    end

    it do
      should validate_presence_of(:staff_id)
        .with_message('is required')
    end

    it do
      should validate_presence_of(:staff_signature)
        .with_message('please sign')
    end

    # Shoulda Matchers may display warnings for boolean inclusion tests.
    it do
      should validate_inclusion_of(:cert_received)
        .in_array([true, false])
        .with_message('must be specified')
    end

    it do
      should validate_inclusion_of(:damage)
        .in_array([true, false])
        .with_message('must be specified')
    end

    it do
      should validate_inclusion_of(:foreign_contam)
        .in_array([true, false])
        .with_message('must be specified')
    end

    it do
      should validate_inclusion_of(:pest_contam)
        .in_array([true, false])
        .with_message('must be specified')
    end

    it do
      should validate_inclusion_of(:satisfactory)
        .in_array([true, false])
        .with_message('must be specified')
    end

    it 'rejects best_before in the past with a custom message' do
      delivery_inspection = build(
        :delivery_inspection,
        best_before: Date.yesterday
      )

      expect(delivery_inspection).to be_invalid
      expect(delivery_inspection.errors[:best_before])
        .to include('cannot be before today')
    end
  end

  describe 'scopes' do
    it 'orders by delivery date descending and breaks ties by created_at descending' do
      oldest = create_di(
        date: Date.new(2025, 1, 10),
        item: item
      )

      older = create_di(
        date: Date.new(2025, 1, 12),
        item: item,
        attrs: { created_at: 1.day.ago }
      )

      newer = create_di(
        date: Date.new(2025, 1, 12),
        item: item,
        attrs: { created_at: Time.current }
      )

      result = DeliveryInspection
               .where(id: [oldest.id, older.id, newer.id])
               .by_delivery_date_desc
               .pluck(:id)

      expect(result).to eq([newer.id, older.id, oldest.id])
    end

    it 'filters by exact item' do
      first_match = create_di(
        date: Date.new(2025, 1, 1),
        item: item
      )

      create_di(
        date: Date.new(2025, 1, 1),
        item: 'Culture'
      )

      second_match = create_di(
        date: Date.new(2025, 1, 2),
        item: item
      )

      expect(DeliveryInspection.for_item(item).pluck(:id).sort)
        .to eq([first_match.id, second_match.id].sort)
    end
  end

  describe '.last_three_for_item' do
    it 'returns the latest three delivery inspections for the item' do
      first = create_di(
        date: Date.new(2025, 1, 1),
        item: item
      )

      second = create_di(
        date: Date.new(2025, 1, 2),
        item: item
      )

      third = create_di(
        date: Date.new(2025, 1, 3),
        item: item
      )

      fourth = create_di(
        date: Date.new(2025, 1, 4),
        item: item
      )

      result = DeliveryInspection.last_three_for_item(item)

      expect(result).to eq([fourth, third, second])
      expect(result).not_to include(first)
    end
  end

  describe 'deletion' do
    it 'prevents deletion when linked to a makesheet' do
      delivery_inspection = create(:delivery_inspection)
      makesheet = create(:makesheet)

      create(
        :ingredient_batch_change,
        delivery_inspection: delivery_inspection,
        makesheet: makesheet
      )

      expect(delivery_inspection.destroy).to be false
      expect(delivery_inspection.errors[:base]).to be_present
      expect(DeliveryInspection.exists?(delivery_inspection.id)).to be true
    end
  end
end