# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Makesheet recent yield (integration)', type: :model do
  def recent_scope
    Makesheet.where('make_date < ?', Date.today).order(make_date: :desc)
  end

  def yield_percent(ms)
    # same formula your model uses
    return 0.0 if ms.milk_used.to_f.zero?
    (ms.total_weight.to_f / ms.milk_used.to_f) * 100.0
  end

  describe '.average_recent_yield' do
    it 'matches the average of the last 10 makesheets (< today), computed directly' do
      rows = recent_scope.limit(10).to_a
      skip 'Not enough historical makesheets to test (need at least 1).' if rows.empty?

      expected = rows.map { |m| yield_percent(m) }.sum / rows.size
      actual   = Makesheet.average_recent_yield(10)

      expect(actual).to be_within(0.001).of(expected)
    end
  end

  describe '#predicted_yield' do
    it 'matches the average of the last 10 rows excluding self, computed directly' do
      me = recent_scope.first
      skip 'Not enough historical makesheets to test (need at least 2).' if me.nil?

      others = recent_scope.where.not(id: me.id).limit(10).to_a
      skip 'Not enough “other” makesheets to test (need at least 1).' if others.empty?

      expected = others.map { |m| yield_percent(m) }.sum / others.size
      actual   = me.predicted_yield

      expect(actual).to be_within(0.001).of(expected)
    end
  end
end

