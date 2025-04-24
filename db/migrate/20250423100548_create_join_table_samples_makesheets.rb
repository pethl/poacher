class CreateJoinTableSamplesMakesheets < ActiveRecord::Migration[7.1]
  def change
    create_join_table :samples, :makesheets do |t|
       t.index [:sample_id, :makesheet_id]
       t.index [:makesheet_id, :sample_id]
    end
  end
end
