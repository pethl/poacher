require "rails_helper"

RSpec.describe GroupPermission, type: :model do
  it { is_expected.to belong_to(:group) }

  it "rejects a resource_key that isn't in PermissionRegistry::RESOURCES" do
    gp = build(:group_permission, resource_key: "not_a_real_model")

    expect(gp).not_to be_valid
    expect(gp.errors[:resource_key]).to be_present
  end

  it "rejects an action that isn't in PermissionRegistry::ACTIONS" do
    gp = build(:group_permission, action: "delete_everything")

    expect(gp).not_to be_valid
    expect(gp.errors[:action]).to be_present
  end

  it "accepts every whitelisted resource_key" do
    group = create(:group, :office)

    PermissionRegistry::RESOURCES.each_key do |key|
      gp = build(:group_permission, group: group, resource_key: key, action: "read")
      expect(gp).to be_valid, "expected resource_key #{key.inspect} to be valid: #{gp.errors.full_messages}"
    end
  end

  it "accepts every whitelisted action" do
    group = create(:group, :office)

    PermissionRegistry::ACTIONS.each do |action|
      gp = build(:group_permission, group: group, resource_key: "sample", action: action.to_s)
      expect(gp).to be_valid, "expected action #{action.inspect} to be valid: #{gp.errors.full_messages}"
    end
  end

  it "won't create the same group/resource/action combination twice" do
    group = create(:group, :office)
    create(:group_permission, group: group, resource_key: "sample", action: "read")
    duplicate = build(:group_permission, group: group, resource_key: "sample", action: "read")

    expect(duplicate).not_to be_valid
  end

  it "allows the same resource_key + action for a different group" do
    office = create(:group, :office)
    hs = create(:group, :hs)
    create(:group_permission, group: office, resource_key: "sample", action: "read")

    elsewhere = build(:group_permission, group: hs, resource_key: "sample", action: "read")

    expect(elsewhere).to be_valid
  end

  it "allows the same group + resource_key with a different action" do
    group = create(:group, :office)
    create(:group_permission, group: group, resource_key: "sample", action: "read")

    different_action = build(:group_permission, group: group, resource_key: "sample", action: "manage")

    expect(different_action).to be_valid
  end

  describe "cache busting" do
    it "clears the group's cached permissions after a create" do
      group = create(:group, :office)
      Rails.cache.write("group_permissions/#{group.id}", ["stale"])

      create(:group_permission, group: group, resource_key: "sample", action: "read")

      expect(Rails.cache.read("group_permissions/#{group.id}")).to be_nil
    end

    it "clears the group's cached permissions after a destroy" do
      group = create(:group, :office)
      gp = create(:group_permission, group: group, resource_key: "sample", action: "read")
      Rails.cache.write("group_permissions/#{group.id}", ["stale"])

      gp.destroy!

      expect(Rails.cache.read("group_permissions/#{group.id}")).to be_nil
    end
  end
end
