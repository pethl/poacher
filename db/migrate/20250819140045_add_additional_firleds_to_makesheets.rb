class AddAdditionalFirledsToMakesheets < ActiveRecord::Migration[7.1]
  def change
    change_table :makesheets, bulk: true do |t|
      t.references :pre_start_inspection_by_2_staff, foreign_key: { to_table: :staffs }, index: true, null: true

      t.time    :seventh_cut_time
      t.decimal :seventh_cut_titration, precision: 6, scale: 4

      t.decimal :freezer_temp,  precision: 4, scale: 1
      t.string  :rennet_used
      t.decimal :rennet_weight_used, precision: 5, scale: 1
      t.decimal :chiller_temp, precision: 4, scale: 1

      t.integer :churns_out
      t.text    :samples_required_summary
    end
  end
end
