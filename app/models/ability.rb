class Ability
  include CanCan::Ability

  # Cache expiry as a safety net alongside the explicit GroupPermission#after_commit bust —
  # so a missed invalidation self-heals within an hour rather than staying stale forever.
  CACHE_TTL = 1.hour

  def initialize(user)
    return unless user # guests: no abilities at all

    if user.in_group?("admin")
      # Admin: unrestricted, including the authorization system itself
      # (Users, Groups, Memberships, GroupPermissions).
      can :manage, :all
      return
    end

    if user.in_group?("mgmt")
      # Mgmt: unrestricted on business data, but cannot touch the auth config.
      can :manage, :all
      cannot :manage, [Group, Membership, GroupPermission, User]
      can :read, User
    end

    # Bounded groups (office, hs, dairy, store, cutting, ...): permissions come from
    # GroupPermission rows, data-driven so adding/removing a model from a group's
    # access doesn't require touching this file or a deploy.
    user.groups.reject(&:blanket?).each do |group|
      permissions = Rails.cache.fetch("group_permissions/#{group.id}", expires_in: CACHE_TTL) do
        group.group_permissions.to_a
      end

      permissions.each do |gp|
        klass = PermissionRegistry::RESOURCES[gp.resource_key]
        next unless klass # defensive: ignore rows referencing a retired/renamed resource

        can gp.action.to_sym, klass
      end
    end
  end
end
