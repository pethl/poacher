class CreateGradingNotes < ActiveRecord::Migration[7.1]
  def change
    create_table :grading_notes do |t|
      t.references :makesheet, null: false, foreign_key: true
      t.date :date
      t.string :appearance
      t.string :bore
      t.string :texture
      t.string :taste
      t.integer :score
      t.text :comments
      t.integer :head_taster
      t.integer :assistant_taster_1
      t.integer :assistant_taster_2

      t.timestamps
    end
  end
end
