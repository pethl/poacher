require "rails_helper"

RSpec.describe Group, type: :model do
  subject { build(:group) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_presence_of(:display_name) }
    it { is_expected.to validate_uniqueness_of(:key) }
    it { is_expected.to validate_inclusion_of(:key).in_array(Group::KEYS) }
  end

  describe "associations" do
    it { is_expected.to have_many(:memberships).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:memberships) }
    it { is_expected.to have_many(:group_permissions).dependent(:destroy) }
  end

  describe ".admin_keys / .blanket_business_keys" do
    it "admin is the only admin_key" do
      expect(Group.admin_keys).to eq(%w[admin])
    end

    it "mgmt is the only blanket_business_key" do
      expect(Group.blanket_business_keys).to eq(%w[mgmt])
    end
  end

  describe "#blanket?" do
    it "is true for admin" do
      expect(build(:group, :admin)).to be_blanket
    end

    it "is true for mgmt" do
      expect(build(:group, :mgmt)).to be_blanket
    end

    it "is false for every bounded group" do
      %i[office hs dairy store cutting].each do |trait|
        expect(build(:group, trait)).not_to be_blanket
      end
    end
  end
end
