class BackfillAdminMemberships < ActiveRecord::Migration[7.1]
  # Scoped, table-only model classes — deliberately NOT the real app models.
  # Migrations should not depend on app/models, since those classes (and their
  # callbacks/validations, e.g. Devise on User) can change shape over time and
  # break old migrations. These minimal classes just talk to the raw tables.
  class MigrationGroup < ActiveRecord::Base
    self.table_name = "groups"
  end

  class MigrationUser < ActiveRecord::Base
    self.table_name = "users"
  end

  class MigrationMembership < ActiveRecord::Base
    self.table_name = "memberships"
  end

  # This migration only needs the "admin" group to exist, so it only creates that one.
  # The full group roster is living reference data, not a one-time schema fixup — it
  # lives in db/seeds.rb, where it can be edited and re-run without touching migration
  # history whenever a group is added, renamed, or retired.
  def up
    admin_group = MigrationGroup.find_or_create_by!(key: "admin") do |g|
      g.display_name = "Admin"
    end

    # Anyone currently flagged admin:true keeps admin access via the new Group system,
    # so nobody loses access the moment this deploys.
    MigrationUser.where(admin: true).find_each do |user|
      MigrationMembership.find_or_create_by!(user_id: user.id, group_id: admin_group.id)
    end
  end

  def down
    admin_group = MigrationGroup.find_by(key: "admin")
    return unless admin_group

    MigrationMembership.where(group_id: admin_group.id).delete_all
    # Leave the admin group row itself — db/seeds.rb owns group existence going forward,
    # and other migrations/records may already reference it by the time this ever runs.
  end
end
