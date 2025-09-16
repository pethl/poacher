# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Makesheet, type: :model do
  describe '#calc_salt_net' do
    it 'returns 0 when milk_used is 0' do
      m = build(:makesheet, milk_used: 0, expected_yield: 25, make_type: 'Cheddar')
      expect(m.calc_salt_net).to eq(0)
    end

    it 'uses expected_yield when present (non-Red type uses factor 0.0002)' do
      m = build(:makesheet, milk_used: 1000, expected_yield: 25, make_type: 'Cheddar')
      # 1000 * 25 * 0.0002 = 5.0
      expect(m.calc_salt_net).to eq(5.0)
    end

    it 'uses the Red factor 0.00021 when make_type is "Red"' do
      m = build(:makesheet, milk_used: 1000, expected_yield: 25, make_type: 'Red')
      # 1000 * 25 * 0.00021 = 5.25
      expect(m.calc_salt_net).to eq(5.25)
    end
  end

  describe '#calc_salt_gross' do
    it 'adds bucket weight from Reference (active, group=bucket_weight)' do
      m = build(:makesheet, milk_used: 1000, expected_yield: 25, make_type: 'Cheddar')
      # stub Reference lookup to return "0.5"
      allow(Reference).to receive_message_chain(:where, :pluck, :first).and_return('0.5')
      # net = 1000 * 25 * 0.0002 = 5.0 ; gross = net + 0.5 = 5.5
      expect(m.calc_salt_gross).to eq(5.5)
    end
  end
end
