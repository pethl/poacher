class DropStaffs < ActiveRecord::Migration[7.1]
  def change
    drop_table :staffs do |t|
      t.string :first_name
      t.string :last_name
      t.string :employment_status
      t.string :dept
      t.string :role
      t.bigint :created_by_id
      t.bigint :updated_by_id
      t.bigint :user_id
      t.timestamps
    end
  end
end
