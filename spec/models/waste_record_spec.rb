require 'rails_helper'

RSpec.describe WasteRecord, type: :model do
  describe 'associations' do
    it { should belong_to(:traceability_record) }

    it do
      should belong_to(:created_by)
        .class_name('User')
        .optional
    end

    it do
      should belong_to(:updated_by)
        .class_name('User')
        .optional
    end
  end

  describe 'validations' do
    subject { build(:waste_record) }

    it { should validate_presence_of(:waste_date) }

    it 'allows only one waste record per traceability record per date' do
      traceability_record = create(:traceability_record)
      waste_date = Date.current

      create(
        :waste_record,
        traceability_record: traceability_record,
        waste_date: waste_date
      )

      duplicate = build(
        :waste_record,
        traceability_record: traceability_record,
        waste_date: waste_date
      )

      expect(duplicate).to be_invalid
      expect(duplicate.errors[:waste_date]).to include(
        'A waste record already exists for this date. Please edit the existing record.'
      )
    end

    it 'allows the same date for a different traceability record' do
      waste_date = Date.current

      create(
        :waste_record,
        traceability_record: create(:traceability_record),
        waste_date: waste_date
      )

      other_record = build(
        :waste_record,
        traceability_record: create(:traceability_record),
        waste_date: waste_date
      )

      expect(other_record).to be_valid
    end
  end

  describe 'scopes' do
    it 'orders records by waste date ascending' do
      later = create(:waste_record, waste_date: Date.current)
      earlier = create(:waste_record, waste_date: Date.current - 1.day)

      result = described_class
               .where(id: [later.id, earlier.id])
               .ordered

      expect(result).to eq([earlier, later])
    end
  end
end