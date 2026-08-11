class CreateGroups < ActiveRecord::Migration[7.1]
  def change
    create_table :groups do |t|
      t.string :key, null: false          # stable machine key, e.g. "dairy", "cheese_store"
      t.string :display_name, null: false # human label, e.g. "Dairy", "Cheese Store"

      t.timestamps
    end

    add_index :groups, :key, unique: true
  end
end
