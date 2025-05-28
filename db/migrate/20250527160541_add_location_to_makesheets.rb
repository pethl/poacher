class AddLocationToMakesheets < ActiveRecord::Migration[7.1]
  def change
    add_reference :makesheets, :location, foreign_key: true # remove `null: false`
  end
end
