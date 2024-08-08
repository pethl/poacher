class AddBatchToMakesheet < ActiveRecord::Migration[7.0]
  def change
     add_column :makesheets, :batch, :string
  end
end
