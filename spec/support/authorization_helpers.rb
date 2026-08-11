# spec/support/authorization_helpers.rb
#
# Small helpers for wiring up group membership + GroupPermission rows in specs, without
# depending on db/seeds/authorization.rb (which is the real business matrix, and will
# drift over time — these helpers test the *mechanism*, not today's specific rules).
module AuthorizationHelpers
  # Puts `user` in the group `key` (admin/mgmt/office/hs/dairy/store/cutting),
  # creating the Group row if it doesn't already exist. Returns the Group.
  def join_group(user, key)
    group = find_or_create_group(key)
    Membership.find_or_create_by!(user: user, group: group)
    group
  end

  # Grants group `group_key` the given `action` on `resource_key` (see
  # PermissionRegistry::RESOURCES for valid keys, PermissionRegistry::ACTIONS for valid
  # actions). Returns the GroupPermission.
  def grant(group_key, resource_key, action)
    group = find_or_create_group(group_key)
    GroupPermission.find_or_create_by!(group: group, resource_key: resource_key.to_s, action: action.to_s)
  end

  private

  def find_or_create_group(key)
    Group.find_or_create_by!(key: key.to_s) { |g| g.display_name = key.to_s.upcase }
  end
end

RSpec.configure do |config|
  config.include AuthorizationHelpers
end
