class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :location_type
      t.integer :sort_order
      t.boolean :active

      t.timestamps
    end
  end
end
