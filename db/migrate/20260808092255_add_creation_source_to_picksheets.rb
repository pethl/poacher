class AddCreationSourceToPicksheets < ActiveRecord::Migration[7.1]

  def change
    rename_column :picksheets, :user_id, :assigned_user_id

    add_column :picksheets,
               :creation_source,
               :integer,
               default: 0,
               null: false

    add_column :picksheets,
               :external_source_name,
               :string

    add_index :picksheets, :creation_source
    add_index :picksheets, :external_source_name

    if index_name_exists?(:picksheets, "index_picksheets_on_user_id")
      rename_index :picksheets,
                   "index_picksheets_on_user_id",
                   "index_picksheets_on_assigned_user_id"
    end
  end
end
