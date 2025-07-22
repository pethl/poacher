class AddFieldsToMakesheet < ActiveRecord::Migration[7.1]
  def change
    change_table :makesheets do |t|
      t.decimal :ta_combined_milk, precision: 4, scale: 2
      t.decimal :whey_ta, precision: 4, scale: 2
      t.decimal :curd_temp, precision: 3, scale: 1
      t.decimal :room_temp, precision: 3, scale: 1
      t.integer :visual_moisture_post_milling
      t.decimal :moisture_percentage_post_milling, precision: 4, scale: 2
      t.text :record_of_works_completed
    end
  end
end
