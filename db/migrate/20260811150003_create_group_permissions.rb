class CreateGroupPermissions < ActiveRecord::Migration[7.1]
  def change
    create_table :group_permissions do |t|
      t.references :group, null: false, foreign_key: true
      t.string :resource_key, null: false # must match a PermissionRegistry::RESOURCES key
      t.string :action, null: false       # must be in PermissionRegistry::ACTIONS

      t.timestamps
    end

    add_index :group_permissions, [:group_id, :resource_key, :action],
              unique: true, name: "index_group_permissions_on_group_resource_action"
  end
end
