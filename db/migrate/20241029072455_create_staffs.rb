class CreateStaffs < ActiveRecord::Migration[7.0]
  def change
    create_table :staffs do |t|
      t.string :first_name
      t.string :last_name
      t.string :employment_status
      t.string :dept
      t.string :role

      t.timestamps
    end
  end
end
