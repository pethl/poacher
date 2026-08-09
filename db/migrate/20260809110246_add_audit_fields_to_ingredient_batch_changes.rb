class AddAuditFieldsToIngredientBatchChanges < ActiveRecord::Migration[7.1]
  def change
    add_reference :ingredient_batch_changes,
                  :created_by,
                  foreign_key: { to_table: :users }

    add_reference :ingredient_batch_changes,
                  :updated_by,
                  foreign_key: { to_table: :users }
  end
end
