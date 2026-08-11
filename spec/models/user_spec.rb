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

  describe "scopes" do
      it ".active returns active users only" do
        active = create(:user, account_active: true)
        inactive = create(:user, account_active: false)

        expect(User.active).to include(active)
        expect(User.active).not_to include(inactive)
      end
    end

  describe "#in_group?" do
    it "is true once the user has joined the group" do
      user = create(:user)
      join_group(user, "dairy")

      expect(user.in_group?("dairy")).to be true
      expect(user.in_group?(:dairy)).to be true # accepts a symbol too
    end

    it "is false for a group the user hasn't joined" do
      user = create(:user)
      join_group(user, "dairy")

      expect(user.in_group?("cutting")).to be false
    end

    it "is false with no group membership at all" do
      user = create(:user)

      expect(user.in_group?("dairy")).to be false
    end
  end

  describe "#can_access_section?" do
    it "is true for a bounded group the user has joined" do
      user = create(:user)
      join_group(user, "office")

      expect(user.can_access_section?("office")).to be true
    end

    it "is false for a bounded section the user hasn't joined" do
      user = create(:user)
      join_group(user, "office")

      expect(user.can_access_section?("dairy")).to be false
    end

    it "is true for any section when the user is admin" do
      user = create(:user)
      join_group(user, "admin")

      expect(user.can_access_section?("dairy")).to be true
      expect(user.can_access_section?("office")).to be true
    end

    it "is true for any section when the user is mgmt" do
      user = create(:user)
      join_group(user, "mgmt")

      expect(user.can_access_section?("dairy")).to be true
      expect(user.can_access_section?("store")).to be true
    end
  end
end
