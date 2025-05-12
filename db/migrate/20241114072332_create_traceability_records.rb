class CreateTraceabilityRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :traceability_records do |t|
      t.references :makesheet, index: true, foreign_key: true
      t.datetime :date_started_batch 
      t.datetime :date_finished_batch
      t.integer :total_weight_of_batch
      t.integer :confirmed_number_of_cheeses
      t.string :all_rinds_visually_clean
      t.decimal :individual_cheese_weight_1, precision: 7, scale: 2 
      t.decimal :individual_cheese_weight_2, precision: 7, scale: 2 
      t.decimal :individual_cheese_weight_3, precision: 7, scale: 2 
      t.decimal :individual_cheese_weight_4, precision: 7, scale: 2 
      t.decimal :individual_cheese_weight_5, precision: 7, scale: 2 
      t.decimal :individual_cheese_weight_6, precision: 7, scale: 2 
      t.decimal :individual_cheese_weight_7, precision: 7, scale: 2 
      t.decimal :individual_cheese_weight_8, precision: 7, scale: 2 
      t.decimal :individual_cheese_weight_9, precision: 7, scale: 2 
      t.decimal :individual_cheese_weight_10, precision: 7, scale: 2 
      t.decimal :individual_cheese_weight_11, precision: 7, scale: 2 
      t.decimal :individual_cheese_weight_12, precision: 7, scale: 2 
      t.decimal :individual_cheese_weight_13, precision: 7, scale: 2 
      t.decimal :individual_cheese_weight_14, precision: 7, scale: 2 
      t.decimal :individual_cheese_weight_15, precision: 7, scale: 2 
      t.decimal :individual_cheese_weight_16, precision: 7, scale: 2 
      t.decimal :individual_cheese_weight_17, precision: 7, scale: 2 
      t.decimal :individual_cheese_weight_18, precision: 7, scale: 2 
      t.decimal :individual_cheese_weight_19, precision: 7, scale: 2 
      t.decimal :individual_cheese_weight_20, precision: 7, scale: 2 
      t.decimal :individual_cheese_weight_21, precision: 7, scale: 2
      t.decimal :individual_cheese_weight_22, precision: 7, scale: 2 
      t.decimal :individual_cheese_weight_23, precision: 7, scale: 2 
      t.decimal :individual_cheese_weight_24, precision: 7, scale: 2 
      t.decimal :individual_cheese_weight_25, precision: 7, scale: 2 
      t.decimal :individual_cheese_weight_26, precision: 7, scale: 2 
      t.decimal :individual_cheese_weight_27, precision: 7, scale: 2
      t.decimal :individual_cheese_weight_28, precision: 7, scale: 2
      t.decimal :individual_cheese_weight_29, precision: 7, scale: 2
      t.decimal :individual_cheese_weight_30, precision: 7, scale: 2
      t.decimal :individual_cheese_weight_31, precision: 7, scale: 2
      t.decimal :individual_cheese_weight_32, precision: 7, scale: 2
      t.decimal :individual_cheese_weight_33, precision: 7, scale: 2
      t.decimal :individual_cheese_weight_34, precision: 7, scale: 2
      t.decimal :individual_cheese_weight_35, precision: 7, scale: 2

      t.timestamps
    end
  end
end
