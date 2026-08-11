require "rails_helper"

# Tests the *mechanism* Ability implements, not today's specific business matrix (that
# lives in db/seeds/authorization.rb and will drift over time). If this spec is green,
# the engine driving the whole authorization system is sound: blanket groups, data-driven
# bounded groups, custom actions, caching, and multi-group membership all behave correctly
# for an arbitrary GroupPermission configuration.
RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  let(:user) { create(:user) }

  describe "guest (no user)" do
    subject(:ability) { Ability.new(nil) }

    it "can do nothing at all" do
      expect(ability.can?(:read, Sample)).to be false
      expect(ability.can?(:manage, Sample)).to be false
    end
  end

  describe "a user with no group membership" do
    it "can do nothing at all" do
      expect(ability.can?(:read, Sample)).to be false
      expect(ability.can?(:manage, Sample)).to be false
    end
  end

  describe "admin group" do
    before { join_group(user, "admin") }

    it "can manage every business model" do
      expect(ability.can?(:manage, Sample)).to be true
      expect(ability.can?(:manage, Makesheet)).to be true
      expect(ability.can?(:manage, Contact)).to be true
    end

    it "can also manage the authorization system itself" do
      expect(ability.can?(:manage, User)).to be true
      expect(ability.can?(:manage, Group)).to be true
      expect(ability.can?(:manage, Membership)).to be true
      expect(ability.can?(:manage, GroupPermission)).to be true
    end
  end

  describe "mgmt group" do
    before { join_group(user, "mgmt") }

    it "can manage business models with no GroupPermission rows needed" do
      expect(ability.can?(:manage, Sample)).to be true
      expect(ability.can?(:manage, Makesheet)).to be true
    end

    it "can read Users but not manage them" do
      expect(ability.can?(:read, User)).to be true
      expect(ability.can?(:manage, User)).to be false
    end

    it "cannot touch the authorization config itself" do
      expect(ability.can?(:manage, Group)).to be false
      expect(ability.can?(:manage, Membership)).to be false
      expect(ability.can?(:manage, GroupPermission)).to be false
    end
  end

  describe "a bounded group (e.g. hs)" do
    it "can do nothing until a GroupPermission row grants it" do
      join_group(user, "hs")

      expect(ability.can?(:manage, Sample)).to be false
    end

    it "can do exactly what its GroupPermission rows say" do
      join_group(user, "hs")
      grant("hs", "sample", :manage)
      grant("hs", "makesheet", :read)

      expect(ability.can?(:manage, Sample)).to be true
      expect(ability.can?(:read, Makesheet)).to be true
    end

    it "does not grant more than the row says" do
      join_group(user, "hs")
      grant("hs", "makesheet", :read)

      expect(ability.can?(:read, Makesheet)).to be true
      expect(ability.can?(:manage, Makesheet)).to be false
    end

    it "does not grant access to a resource with no row at all" do
      join_group(user, "hs")
      grant("hs", "sample", :manage)

      expect(ability.can?(:read, Contact)).to be false
    end

    it "does not leak access to a different group's permissions" do
      join_group(user, "hs")
      grant("dairy", "sample", :manage) # granted to a group this user isn't in

      expect(ability.can?(:manage, Sample)).to be false
    end
  end

  describe "custom (non-CRUD) actions" do
    before do
      join_group(user, "store")
      grant("store", "makesheet", :print_labels)
      grant("store", "makesheet", :assign_location)
    end

    it "grants exactly the custom action" do
      expect(ability.can?(:print_labels, Makesheet)).to be true
      expect(ability.can?(:assign_location, Makesheet)).to be true
    end

    it "does not imply :read or :manage" do
      expect(ability.can?(:read, Makesheet)).to be false
      expect(ability.can?(:manage, Makesheet)).to be false
    end
  end

  describe "manage implies read (CanCan semantics)" do
    it "a :manage grant also passes a :read check" do
      join_group(user, "dairy")
      grant("dairy", "makesheet", :manage)

      expect(ability.can?(:read, Makesheet)).to be true
    end
  end

  describe "membership in multiple bounded groups" do
    it "unions permissions across every group the user belongs to" do
      join_group(user, "hs")
      join_group(user, "cutting")
      grant("hs", "sample", :manage)
      grant("cutting", "breakage", :manage)

      expect(ability.can?(:manage, Sample)).to be true
      expect(ability.can?(:manage, Breakage)).to be true
    end
  end

  describe "a retired/unknown resource_key on a GroupPermission row" do
    it "is ignored defensively rather than blowing up" do
      group = join_group(user, "hs")
      # bypass GroupPermission's own validation to simulate a stale row left behind after
      # a resource_key was renamed or removed from PermissionRegistry::RESOURCES
      GroupPermission.insert_all([
        { group_id: group.id, resource_key: "no_longer_a_real_model", action: "manage",
          created_at: Time.current, updated_at: Time.current }
      ])

      expect { ability }.not_to raise_error
    end
  end

  # Rails.cache is :null_store in test (config/environments/test.rb), so these don't
  # actually exercise GroupPermission's Rails.cache-busting path — that's covered
  # (if a little vacuously, for the same null_store reason) in group_permission_spec.rb.
  # What these do verify: a fresh Ability picks up the current GroupPermission state.
  # `user.reload` is needed between steps because `user` is memoized for the whole
  # example — without it, `user.groups`/`group.group_permissions` stay cached on that
  # same Ruby object across both Ability.new(user) calls. A real request never hits this,
  # since Devise loads current_user fresh every time.
  describe "reflecting the current GroupPermission state" do
    it "picks up a newly granted permission on a fresh Ability instance" do
      join_group(user, "office")
      expect(ability.can?(:read, Contact)).to be false

      grant("office", "contact", :read)
      user.reload

      expect(Ability.new(user).can?(:read, Contact)).to be true
    end

    it "stops granting access once a permission is revoked" do
      join_group(user, "office")
      gp = grant("office", "contact", :read)
      user.reload
      expect(Ability.new(user).can?(:read, Contact)).to be true

      gp.destroy!
      user.reload

      expect(Ability.new(user).can?(:read, Contact)).to be false
    end
  end
end
