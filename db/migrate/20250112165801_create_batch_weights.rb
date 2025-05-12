class CreateBatchWeights < ActiveRecord::Migration[7.0]
  def change
    create_table :batch_weights do |t|
      t.date :date
      t.references :makesheet, index: true, foreign_key: true
      t.decimal :washed_batch_weight, precision: 7, scale: 2
      t.decimal :total_waste, precision: 7, scale: 2
      t.string :comments

      t.timestamps
    end
  end
end
