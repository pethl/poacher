class AddUserReferenceToStaff < ActiveRecord::Migration[7.1]
  def change
    add_reference :staffs, :user, foreign_key: true
  end
end
