class ChangeDefaultStatusInPicksheets < ActiveRecord::Migration[7.0]
  def change
    change_column_default :picksheets, :status, from: "Open", to: "Assigned"
  end
end
