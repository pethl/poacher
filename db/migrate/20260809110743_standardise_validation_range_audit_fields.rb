class StandardiseValidationRangeAuditFields < ActiveRecord::Migration[7.1]
  def change
    rename_column :validation_ranges, :created_by, :created_by_id
    rename_column :validation_ranges, :updated_by, :updated_by_id

    change_column :validation_ranges, :created_by_id, :bigint
    change_column :validation_ranges, :updated_by_id, :bigint

    add_index :validation_ranges, :created_by_id
    add_index :validation_ranges, :updated_by_id

    add_foreign_key :validation_ranges,
                    :users,
                    column: :created_by_id

    add_foreign_key :validation_ranges,
                    :users,
                    column: :updated_by_id
  end
end