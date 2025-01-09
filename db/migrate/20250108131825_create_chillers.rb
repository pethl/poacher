class CreateChillers < ActiveRecord::Migration[7.0]
  def change
    create_table :chillers do |t|
      t.date :date
      t.decimal :chiller_1, precision: 5, scale: 2
      t.decimal :chiller_2, precision: 5, scale: 2
      t.string :action_taken
      t.references :staff, index: true, foreign_key: true

      t.timestamps
    end
  end
end
