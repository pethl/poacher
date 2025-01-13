class CreateMilkQualityMonitors < ActiveRecord::Migration[7.0]
  def change
    create_table :milk_quality_monitors do |t|
      t.date :sample_date
      t.references :makesheet, index: true, foreign_key: true
      t.integer :cell_count
      t.integer :bactoscan
      t.float :butterfat, precision: 6, scale: 3
      t.float :lactose, precision: 6, scale: 3
      t.float :protein, precision: 6, scale: 3
      t.float :casein, precision: 6, scale: 3
      t.float :urea, precision: 6, scale: 3
      t.float :total_viable_colonies, precision: 6, scale: 3
      t.float :therms, precision: 6, scale: 3
      t.float :coliforms, precision: 6, scale: 3

      t.timestamps
    end
  end
end
