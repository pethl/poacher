class CreateBatchWeights < ActiveRecord::Migration[7.0]
  def change
    create_table :batch_weights do |t|
      t.date :date
      t.references :makesheet, index: true, foreign_key: true
      t.decimal :washed_batch_weight, precision: 7, scale: 2
      t.string :all_rinds_visually_clean
      t.string :comments

      t.timestamps
    end
  end
end
