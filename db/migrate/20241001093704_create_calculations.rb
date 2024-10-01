class CreateCalculations < ActiveRecord::Migration[7.0]
  def change
    create_table :calculations do |t|
      t.string :product
      t.string :size
      t.integer :weight
      t.string :notes

      t.timestamps
    end
  end
end
