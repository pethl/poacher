class CreateTurns < ActiveRecord::Migration[7.0]
  def change
    create_table :turns do |t|
      t.datetime :turn_date
      t.references :makesheet, null: false, foreign_key: true
      t.string :turned_by

      t.timestamps
    end
  end
end
