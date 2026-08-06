class ChangeTurnDateToDate < ActiveRecord::Migration[7.1]
  def change
    change_column :turns, :turn_date, :date

    add_index :turns,
              [:makesheet_id, :turn_date],
              unique: true,
              name: "index_turns_on_makesheet_and_turn_date"
  end
end
