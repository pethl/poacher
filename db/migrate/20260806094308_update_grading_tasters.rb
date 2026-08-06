class UpdateGradingTasters < ActiveRecord::Migration[7.1]
  def change
    remove_column :grading_notes, :head_taster, :integer
    remove_column :grading_notes, :assistant_taster_1, :integer
    remove_column :grading_notes, :assistant_taster_2, :integer

    add_reference :grading_notes,
                  :head_taster,
                  null: false,
                  foreign_key: { to_table: :users }

    add_column :grading_notes, :taster_1_name, :string
    add_column :grading_notes, :taster_2_name, :string
  end
end
