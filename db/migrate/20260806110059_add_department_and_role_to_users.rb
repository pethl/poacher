class AddDepartmentAndRoleToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :dept, :string
    add_column :users, :title, :string
    add_column :users, :employment_status, :string
  end
end
