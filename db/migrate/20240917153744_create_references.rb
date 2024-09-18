class CreateReferences < ActiveRecord::Migration[7.0]
  def change
    create_table :references do |t|
      t.string :group
      t.string :value
      t.string :description
      t.boolean :active, :default => true

      t.timestamps
    end
  end
end
