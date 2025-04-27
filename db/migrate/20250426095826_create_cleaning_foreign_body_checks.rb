class CreateCleaningForeignBodyChecks < ActiveRecord::Migration[7.1]
  def change
    create_table :cleaning_foreign_body_checks do |t|
      t.date :date
      t.boolean :milk_pipeline
      t.boolean :cheese_vat
      t.boolean :used_mill
      t.boolean :cooler_moulds_tables
      t.boolean :hand_equipment
      t.boolean :blue_food_contact_equipment
      t.boolean :plastic_sleeves
      t.boolean :metal_shovels
      t.boolean :aprons
      t.boolean :drain_lower_level
      t.boolean :drain_upper_level
      t.boolean :presses
      t.boolean :sinks
      t.boolean :floor_difficult_areas
      t.boolean :footbaths
      t.boolean :internal_door_handles
      t.boolean :change_chlorine
      t.boolean :floor_under_handwash
      t.boolean :compressors
      t.text :additional_comments
      
      t.references :staff, foreign_key: true
      t.bigint :staff_id_2
      t.bigint :staff_id_3

      t.timestamps
    end

  
  end
end

