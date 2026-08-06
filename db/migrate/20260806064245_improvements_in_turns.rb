class ImprovementsInTurns < ActiveRecord::Migration[7.1]
  def change
    remove_column :turns, :turned_by, :string

    add_column :turns,
               :turn_method,
               :string,
               null: false,
               default: "Manual"

    add_reference :turns,
                  :turned_by,
                  foreign_key: { to_table: :users }
  end
end
