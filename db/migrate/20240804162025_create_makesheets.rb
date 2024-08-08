class CreateMakesheets < ActiveRecord::Migration[7.0]
  def change
    create_table :makesheets do |t|
      t.datetime :make_date
      t.integer :milk_used
      t.integer :total_weight
      t.integer :number_of_cheeses
      t.string :grade
      t.string :weight_type

      t.timestamps
    end
  end
end
