class AddModelToReferences < ActiveRecord::Migration[7.1]
  def change
    add_column :references, :model, :string
    add_column :references, :sort_order, :integer
  end
end
