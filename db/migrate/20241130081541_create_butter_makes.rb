class CreateButterMakes < ActiveRecord::Migration[7.0]
  def change
    create_table :butter_makes do |t|
      t.date :date
      t.integer :cream
      t.integer :make
      t.integer :stock

      t.timestamps
    end
  end
end
