class CreateSamples < ActiveRecord::Migration[7.0]
  def change
    create_table :samples do |t|
      t.string :indicator
      t.string :sample_no
      t.datetime :received_date
      t.string :sample_description
      t.references :makesheet, index: true, foreign_key: true
      t.string :suite
      t.string :classification
      t.string :schedule
      t.string :barcode_count
      t.string :coagulase_positive_staphylococcus_37c_umqv9
      t.string :coagulase_positive_staphylococcus_37c_umqzw
      t.string :escherichia_coli_b_glucuronidase
      t.string :listeria_species
      t.string :listeria_species_37
      t.string :presumptive_coliforms
      t.string :salmonella
      t.string :staphylococcus_aureus_enterotoxins

      t.timestamps
    end
  end
end
