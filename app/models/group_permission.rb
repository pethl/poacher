class GroupPermission < ApplicationRecord
  belongs_to :group

  validates :resource_key, inclusion: { in: -> { PermissionRegistry::RESOURCES.keys } }
  validates :action, inclusion: { in: -> { PermissionRegistry::ACTIONS.map(&:to_s) } }
  validates :resource_key, uniqueness: { scope: %i[group_id action] }

  after_commit :bust_ability_cache

  private

  def bust_ability_cache
    Rails.cache.delete("group_permissions/#{group_id}")
  end
end
