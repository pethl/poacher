class CreateScaleChecks < ActiveRecord::Migration[7.1]
  def change
    create_table :scale_checks do |t|
      t.string :frequency
      t.date :check_date
      t.string :scale_name
      t.boolean :scale_100g
      t.boolean :scale_500g
      t.boolean :scale_1kg
      t.boolean :scale_5kg
      t.boolean :scale_10kg
      t.boolean :scale_20kg
      t.string :comments
      t.text :signature
      t.references :staff, null: false, foreign_key: true

      t.timestamps
    end
  end
end
