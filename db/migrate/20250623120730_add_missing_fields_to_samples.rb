class AddMissingFieldsToSamples < ActiveRecord::Migration[7.1]
  def change
    change_table :samples, bulk: true do |t|
      t.string :aerobic_plate_count_22c_3_days
      t.string :aerobic_plate_count_30c
      t.string :aerobic_plate_count_37c_2_days
      t.string :ash
      t.string :campylobacter_species_10g
      t.string :campylobacter_species_25g
      t.string :carbohydrates
      t.string :crude_protein
      t.string :energy_kcal
      t.string :energy_kj
      t.string :escherichia_coli_100ml
      t.string :escherichia_coli_o157
      t.string :fructose
      t.string :galactose
      t.string :glucose
      t.string :histamine
      t.string :identification_listeria_species_1
      t.string :lactose
      t.string :listeria_species_swab
      t.string :listeria_species_confirmation_maldi
      t.string :maltose
      t.string :moisture
      t.string :monounsaturated_fatty_acids
      t.string :ph
      t.string :polyunsaturated_fatty_acids
      t.string :presumptive_coliforms_swab
      t.string :presumptive_enterobacteriaceae
      t.string :salt
      t.string :saturated_fatty_acids
      t.string :sodium
      t.string :sucrose
      t.string :total_coliforms_100ml
      t.string :total_dietary_fibre
      t.string :total_fat
      t.string :total_sugars
      t.string :trans_fatty_acids_per_fat
      t.string :trans_fatty_acids
      t.string :water_activity
    end
  end
end
