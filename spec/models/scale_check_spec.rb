# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScaleCheck, type: :model do
  describe 'associations' do
    it { should belong_to(:user).optional }
    it { should belong_to(:created_by).class_name('User').optional }
    it { should belong_to(:updated_by).class_name('User').optional }
  end

  describe 'validations' do
    subject { FactoryBot.create(:scale_check) }

    it { should validate_presence_of(:scale_name) }
    it { should validate_presence_of(:check_date) }
    it { should validate_presence_of(:frequency) }

    it do
      should validate_uniqueness_of(:check_date)
        .scoped_to(:scale_name, :frequency)
        .with_message("Already have a record for this scale and date.")
    end

    it 'requires a user' do
      scale_check = FactoryBot.build(:scale_check, user: nil)
      scale_check.validate

      expect(scale_check.errors[:user_id]).to include("Please identify yourself.")
    end
  end
end