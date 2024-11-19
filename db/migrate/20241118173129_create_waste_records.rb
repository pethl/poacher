class CreateWasteRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :waste_records do |t|
      t.references :traceability_record, null: false, foreign_key: true
      t.date :waste_date, null: false
      t.decimal :wedges, precision: 7, scale: 2
      t.decimal :cooking, precision: 7, scale: 2
      t.decimal :blue, precision: 7, scale: 2
      t.decimal :t_and_bs, precision: 7, scale: 2
      t.decimal :waste, precision: 7, scale: 2

      t.timestamps
    end
   
  end
end
