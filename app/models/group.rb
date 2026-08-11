class Group < ApplicationRecord
  KEYS = %w[admin mgmt office hs dairy store cutting].freeze

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :group_permissions, dependent: :destroy

  validates :key, presence: true, uniqueness: true, inclusion: { in: KEYS }
  validates :display_name, presence: true

  # Groups with unrestricted access to everything, incl. auth config (Users, Groups, GroupPermissions).
  def self.admin_keys
    %w[admin]
  end

  # Groups with unrestricted access to business models, but not the auth config itself.
  def self.blanket_business_keys
    %w[mgmt]
  end

  def blanket?
    self.class.admin_keys.include?(key) || self.class.blanket_business_keys.include?(key)
  end
end
