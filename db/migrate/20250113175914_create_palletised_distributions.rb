class CreatePalletisedDistributions < ActiveRecord::Migration[7.0]
  def change
    create_table :palletised_distributions do |t|
      t.date :date
      t.string :company_name
      t.string :registration
      t.string :trailer_number_type
      t.float :temperature, precision: 4, scale: 2
      t.boolean :vehicle_clean
      t.string :destination
      t.integer :number_of_pallets
      t.references :staff, index: true, foreign_key: true
      t.string :drivers_signature

      t.timestamps
    end
  end
end
