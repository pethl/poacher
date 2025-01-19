class CreateMakesheets < ActiveRecord::Migration[7.0]
  def change
    create_table :makesheets do |t|
      t.string :status, :default => 'Created'
      t.datetime :make_date
      t.string :make_type
      t.integer :milk_used
      t.float :total_weight, precision: 6, scale: 3
      t.integer :number_of_cheeses
      t.string :weight_type
      t.string :grade
      t.time  :boiler_on_time
      t.time  :steam_hot_water_on_time
      t.time  :cold_milk_in_time
      t.string  :cold_milk_in_state
      t.time  :warm_milk_finish_time
      t.float  :warm_milk_finish_titration, precision: 6, scale: 3
      t.time  :starter_in_time
      t.float :starter_in_temp, precision: 6, scale: 3
      t.time  :heat_off_1_time
      t.float  :heat_off_1_temp, precision: 6, scale: 3
      t.time  :milk_titration_time
      t.float  :milk_titration_temp, precision: 6, scale: 3
      t.time  :rennet_time
      t.float  :rennet_temp, precision: 6, scale: 3
      t.time  :cut_start_time
      t.time  :cut_end_time
      t.time  :heat_on_time
      t.time  :heat_off_2_time
      t.float  :heat_off_2_temp, precision: 6, scale: 3
      t.time  :pitch_time
      t.time  :whey_time
      t.float  :whey_titration, precision: 6, scale: 3
      t.time  :first_cut_time
      t.float  :first_cut_titration, precision: 6, scale: 3
      t.time  :second_cut_time
      t.float  :second_cut_titration, precision: 6, scale: 3
      t.time  :third_cut_time
      t.float  :third_cut_titration, precision: 6, scale: 3
      t.string  :identify_mill_used
      t.boolean  :warm_am 
      t.boolean  :twelve_hr_pm
      t.string  :unusual_smell_appearance
      t.integer  :number_of_bottles_from_fm
      t.datetime :use_by_date_milk_from_fm
      t.string  :type_of_starter_culture_used
      t.float  :qty_of_starter_used, precision: 6, scale: 4
      t.boolean  :pre_start_inspection_of_high_risk_items
      t.integer :pre_start_inspection_by_staff_id
      t.text  :ingredient_batch_change
      t.string  :thermometer_change
      t.string  :scale_change
      t.boolean  :batch_dipped
      t.text  :post_make_notes
      t.integer :cheese_made_by_staff_id
      t.string  :milling_help
      t.float  :salt_weight_net, precision: 6, scale: 3
      t.float  :salt_weight_gross, precision: 6, scale: 3
      t.string  :weather_today
      t.float  :weather_temp, precision: 6, scale: 3
      t.float  :weather_humidity, precision: 6, scale: 3
      t.boolean  :glass_breakage
      t.boolean  :glass_contamination
      t.text  :glass_comments
      t.boolean  :metal_breakage
      t.boolean  :metal_contamination
      t.text  :metal_comments

      t.timestamps
    end

    add_index :makesheets, :status
    add_index :makesheets, :make_date

  end
end
