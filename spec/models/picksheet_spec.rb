require 'rails_helper'

RSpec.describe Picksheet, type: :model do
  describe 'associations' do
    it { should have_many(:picksheet_items).dependent(:destroy) }
    it { should have_many(:wash_picksheets) }
    it { should have_many(:washes).through(:wash_picksheets) }
    it { should belong_to(:user) }
    it { should belong_to(:contact) }
  end

  describe 'validations' do
    it { should validate_presence_of(:date_order_placed) }
    it { should validate_presence_of(:contact_id) }
  end

  describe 'scopes' do
    it 'returns in ascending order of date_order_placed' do
      p1 = FactoryBot.create(:picksheet, date_order_placed: Date.new(2023, 5, 1))
      p2 = FactoryBot.create(:picksheet, date_order_placed: Date.new(2023, 5, 2))
      result = Picksheet.where(id: [p1.id, p2.id]).ordered
      expect(result).to eq([p1, p2])
    end
  end

  describe '#number_of_products' do
    it 'returns count of associated picksheet_items' do
      picksheet = FactoryBot.create(:picksheet)
      FactoryBot.create_list(:picksheet_item, 3, picksheet: picksheet)
      expect(picksheet.number_of_products).to eq(3)
    end
  end

  describe '#picksheet_title_detail' do
    it 'returns formatted delivery date, contact name, and product count' do
      picksheet = FactoryBot.create(:picksheet, delivery_required_by: Date.new(2025, 5, 1))
      FactoryBot.create_list(:picksheet_item, 2, picksheet: picksheet)
      expect(picksheet.picksheet_title_detail).to eq("Due: May 01, 2025 - #{picksheet.contact.business_name}, Products: 2")
    end
  end

  describe '#full_delivery_info' do
    it 'returns formatted date and time if present' do
      picksheet = FactoryBot.build(:picksheet, delivery_required_by: Date.new(2025, 5, 2), delivery_time_of_day: "AM")
      expect(picksheet.full_delivery_info).to eq("May 02, 2025 (AM)")
    end

    it 'returns date only if time is missing' do
      picksheet = FactoryBot.build(:picksheet, delivery_required_by: Date.new(2025, 5, 2), delivery_time_of_day: nil)
      expect(picksheet.full_delivery_info).to eq("May 02, 2025")
    end

    it 'returns empty string if date is nil' do
      picksheet = FactoryBot.build(:picksheet, delivery_required_by: nil)
      expect(picksheet.full_delivery_info).to eq("")
    end
  end
end
