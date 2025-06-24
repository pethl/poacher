class AddTotalHoursAndMinutesAndFinalTitrationToMakesheets < ActiveRecord::Migration[7.1]
  def change
    add_column :makesheets, :total_hours, :integer
    add_column :makesheets, :total_minutes, :integer
    add_column :makesheets, :final_titration, :decimal, precision: 6, scale: 4
  end
end
