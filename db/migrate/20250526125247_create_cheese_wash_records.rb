class CreateCheeseWashRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :cheese_wash_records do |t|
      t.references :makesheet, null: false, foreign_key: true
      t.date :date_batch_started
      t.date :date_batch_finished

      (1..24).each do |i|
        t.date    "wash_date_#{i}"
        t.integer "number_washed_#{i}", default: 0
      end

      t.timestamps
    end
  end
end
