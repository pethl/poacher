require 'rails_helper'

RSpec.describe Turn, type: :model do
  describe 'associations' do
  it { should belong_to(:makesheet) }

  

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
    subject do
      build(
        :turn,
        turn_method: 'Manual',
        turned_by: build(:user)
      )
    end

    it { should validate_presence_of(:turn_date) }
    it { should validate_presence_of(:turn_method) }

    it do
      should validate_inclusion_of(:turn_method)
        .in_array(Turn::TURN_METHODS)
    end

    it 'requires turned_by for a manual turn' do
      turn = build(
        :turn,
        turn_method: 'Manual',
        turned_by: nil
      )

      expect(turn).to be_invalid
      expect(turn.errors[:turned_by]).to include("can't be blank")
    end

    it 'allows turned_by to be blank for a Florence turn' do
      turn = build(
        :turn,
        turn_method: 'Florence',
        turned_by: nil
      )

      expect(turn).to be_valid
    end

    it 'allows only one turn per makesheet per date' do
      makesheet = create(:makesheet)
      turn_date = Date.current

      create(
        :turn,
        makesheet: makesheet,
        turn_date: turn_date,
        turn_method: 'Florence'
      )

      duplicate = build(
        :turn,
        makesheet: makesheet,
        turn_date: turn_date,
        turn_method: 'Florence'
      )

      expect(duplicate).to be_invalid
      expect(duplicate.errors[:turn_date]).to include(
        'This batch has already been turned on this date.'
      )
    end

    it 'allows the same date for a different makesheet' do
      turn_date = Date.current

      create(
        :turn,
        makesheet: create(:makesheet),
        turn_date: turn_date,
        turn_method: 'Florence'
      )

      other_turn = build(
        :turn,
        makesheet: create(:makesheet),
        turn_date: turn_date,
        turn_method: 'Florence'
      )

      expect(other_turn).to be_valid
    end
  end

  describe 'scopes' do
    it 'orders turns by turn_date descending' do
      earlier = create(
        :turn,
        turn_date: Date.new(2023, 4, 20),
        turn_method: 'Florence'
      )

      later = create(
        :turn,
        turn_date: Date.new(2023, 5, 20),
        turn_method: 'Florence'
      )

      result = described_class
               .where(id: [earlier.id, later.id])
               .ordered
               .pluck(:turn_date)

      expect(result).to eq([later.turn_date, earlier.turn_date])
    end
  end
end