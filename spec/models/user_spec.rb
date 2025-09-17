# frozen_string_literal: true
require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:picksheets).with_foreign_key(:contact_id) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_presence_of(:password).on(:create) }
  end

  describe "#full_name" do
    it "concatenates first and last name" do
      user = build(:user, first_name: "Jane", last_name: "Doe")
      expect(user.full_name).to eq("Jane Doe")
    end

    it "handles missing last name gracefully" do
      user = build(:user, first_name: "Jane", last_name: nil)
      expect(user.full_name).to eq("Jane")
    end
  end

  describe "callbacks" do
    let(:user) { build(:user) }

    it "sends a welcome email after create" do
      expect(UserMailer).to receive_message_chain(:welcome_email, :deliver_later)
      user.save!
    end

    it "notifies admin after create" do
      expect(UserMailer).to receive_message_chain(:new_user_notification, :deliver_later)
      user.save!
    end
  end
end
