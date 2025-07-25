class CreateValidationRanges < ActiveRecord::Migration[7.1]
  def change
    create_table :validation_ranges do |t|
      t.string  :target_model
      t.string  :field_name
      t.float   :min_value
      t.float   :max_value
      t.boolean :active
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
