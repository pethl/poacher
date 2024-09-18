class CreateWashPicksheets < ActiveRecord::Migration[7.0]
  def change
    create_table :wash_picksheets do |t|
      t.references :wash, null: false, foreign_key: true
      t.references :picksheet, null: false, foreign_key: true

      t.timestamps
    end
  end
end
