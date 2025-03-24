class CreateWashes < ActiveRecord::Migration[7.0]
  def change
    create_table :washes do |t|
      t.datetime :action_date
      t.string :wash_status
      #might ass user id or staff id here later

      t.timestamps
    end
  end
end
