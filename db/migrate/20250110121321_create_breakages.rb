class CreateBreakages < ActiveRecord::Migration[7.0]
  def change
    create_table :breakages do |t|
      t.date :date
      t.boolean :breakage_occured
      t.boolean :knife
      t.boolean :cutting_board_cutting_wire
      t.boolean :ringing_machine_cutting_wire
      t.boolean :cutting_spring
      t.integer :wire_broken_into_2
      t.integer :wire_unwound
      t.integer :other_number
      t.string :other_desc
      t.boolean :product_contaminated
      t.string :action_taken
      t.references :staff, index: true, foreign_key: true


      t.timestamps
    end
  end
end
