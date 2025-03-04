class AddIndexesAndForeignKeysToPicksheets < ActiveRecord::Migration[7.1]
  def change
    # Add indexes for faster lookup
    add_index :picksheets, :contact_id
    add_index :picksheets, :user_id

    # Only add foreign keys if the referenced tables exist
    if table_exists?(:contacts)
      add_foreign_key :picksheets, :contacts, column: :contact_id
    end

    if table_exists?(:users)
      add_foreign_key :picksheets, :users, column: :user_id
    end
  end
end
