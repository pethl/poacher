class CreateIngredientBatchChanges < ActiveRecord::Migration[7.1]
  def change
    create_table :ingredient_batch_changes do |t|
      t.references :makesheet, null: false, foreign_key: true
      t.references :delivery_inspection, null: false, foreign_key: true
      t.string :item
      t.date :changed_on
      t.text :notes

      t.timestamps
    end
  end
end
