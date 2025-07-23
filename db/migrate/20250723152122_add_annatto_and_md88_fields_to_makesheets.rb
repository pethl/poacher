class AddAnnattoAndMd88FieldsToMakesheets < ActiveRecord::Migration[7.1]
  def change
    change_table :makesheets do |t|
      t.time   :annatto_in_time
      t.float  :annatto_in_temp
      t.time   :md_88_in_time
      t.float  :md_88_in_temp
      t.text   :md_88_qty_used
    end
  end
end
