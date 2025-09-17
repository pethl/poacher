# spec/models/delivery_inspection_spec.rb
require 'rails_helper'

RSpec.describe DeliveryInspection, type: :model do
  let(:item) { 'Rennet - Vegetable' }

  # tiny helper to keep builds consistent
  def create_di(date:, item: 'Rennet - Vegetable', attrs: {})
    create(:delivery_inspection, { delivery_date: date, item: item }.merge(attrs))
  end

  describe 'associations' do
    it { should belong_to(:staff) }
    it { should have_many(:ingredient_batch_changes).dependent(:nullify) }
    it { should have_many(:makesheets).through(:ingredient_batch_changes) }
  end

  describe 'validations' do
    subject { build(:delivery_inspection) }

    it { should validate_presence_of(:delivery_date).with_message('Delivery date must be provided') }
    it { should validate_presence_of(:item).with_message('Item must be selected') }
    it { should validate_presence_of(:batch_no).with_message('Batch No. must be entered') }
    it { should validate_presence_of(:best_before).with_message('Best before date must be entered') }
    it { should validate_presence_of(:staff_id).with_message('is required') }
    it { should validate_presence_of(:staff_signature).with_message('please sign') }

    # (keep the shoulda boolean warnings if you like; they’re advisory only)
    it { should validate_inclusion_of(:cert_received).in_array([true, false]).with_message('must be specified') }
    it { should validate_inclusion_of(:damage).in_array([true, false]).with_message('must be specified') }
    it { should validate_inclusion_of(:foreign_contam).in_array([true, false]).with_message('must be specified') }
    it { should validate_inclusion_of(:pest_contam).in_array([true, false]).with_message('must be specified') }
    it { should validate_inclusion_of(:satisfactory).in_array([true, false]).with_message('must be specified') }

    it 'rejects best_before in the past with custom message' do
      di = build(:delivery_inspection, best_before: Date.yesterday)
      expect(di).to be_invalid
      expect(di.errors[:best_before]).to include('cannot be before today')
    end
  end

  describe 'scopes' do
    it 'by_delivery_date_desc: newest first; ties break by created_at desc' do
      # exactly 3 records; 2 share the same date to test created_at tie-break
      oldest = create_di(date: Date.new(2025, 1, 10), item: item)
      older  = create_di(date: Date.new(2025, 1, 12), item: item, attrs: { created_at: 1.day.ago })
      newer  = create_di(date: Date.new(2025, 1, 12), item: item, attrs: { created_at: Time.current })

      expect(
        DeliveryInspection.where(id: [oldest.id, older.id, newer.id])
                          .by_delivery_date_desc
                          .pluck(:id)
      ).to eq([newer.id, older.id, oldest.id])
    end

    it 'for_item filters by exact item' do
      a = create_di(date: Date.new(2025, 1, 1), item: item)
      _ = create_di(date: Date.new(2025, 1, 1), item: 'Culture')
      c = create_di(date: Date.new(2025, 1, 2), item: item)

      expect(DeliveryInspection.for_item(item).pluck(:id).sort).to eq([a.id, c.id].sort)
    end
  end

  describe '.last_three_for_item' do
    it 'returns exactly the latest 3 for item (by delivery_date desc)' do
      # only 4 total records for the target item → expect top 3
      r1 = create_di(date: Date.new(2025, 1, 1), item: item)
      r2 = create_di(date: Date.new(2025, 1, 2), item: item)
      r3 = create_di(date: Date.new(2025, 1, 3), item: item)
      r4 = create_di(date: Date.new(2025, 1, 4), item: item)

      expect(DeliveryInspection.last_three_for_item(item)).to eq([r4, r3, r2])
      expect(DeliveryInspection.last_three_for_item(item)).not_to include(r1)
    end
  end
end

