require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe 'associations' do
    it { should have_many(:picksheets).with_foreign_key('contact_id') }
    it { should have_many(:makesheets) }
  end

  describe 'scopes' do
    it 'orders contacts by business_name ascending (within test records)' do
      c1 = FactoryBot.create(:contact, business_name: "Zebra Ltd")
      c2 = FactoryBot.create(:contact, business_name: "Alpha Co")
  
      scoped = Contact.where(id: [c1.id, c2.id]).ordered
  
      expect(scoped.pluck(:business_name)).to eq(["Alpha Co", "Zebra Ltd"])
    end
  end
  

  describe '#payment_terms' do
    it 'returns Pre Payment Required if pre_payment is true' do
      contact = FactoryBot.build(:contact, pre_payment: true)
      expect(contact.payment_terms).to eq("Pre Payment Required")
    end

    it 'returns Payment on Receipt if payment_on_receipt is true' do
      contact = FactoryBot.build(:contact, payment_on_receipt: true)
      expect(contact.payment_terms).to eq("Payment on Receipt")
    end

    it 'returns X Days After Invoice if days_after_invoice is set' do
      contact = FactoryBot.build(:contact, days_after_invoice: 14)
      expect(contact.payment_terms).to eq("14 Days After Invoice")
    end

    it 'returns empty string if no payment terms are set' do
      contact = FactoryBot.build(:contact)
      expect(contact.payment_terms).to eq("")
    end
  end

  describe 'custom validation' do
    it 'allows only one payment term to be selected' do
      contact = FactoryBot.build(:contact, pre_payment: true, payment_on_receipt: true)
      expect(contact.valid?).to be false
      expect(contact.errors[:base]).to include("Only one payment term can be selected")
    end

    it 'is valid when only one payment option is set' do
      c1 = FactoryBot.build(:contact, pre_payment: true)
      c2 = FactoryBot.build(:contact, payment_on_receipt: true)
      c3 = FactoryBot.build(:contact, days_after_invoice: 30)

      expect(c1).to be_valid
      expect(c2).to be_valid
      expect(c3).to be_valid
    end
  end
end
