class ImproveTraceabilityRecordIntegrity < ActiveRecord::Migration[7.1]
  def change
    remove_index :traceability_records, :makesheet_id

    add_index :traceability_records,
              :makesheet_id,
              unique: true

    change_column :traceability_records,
                  :total_weight_of_batch,
                  :decimal,
                  precision: 8,
                  scale: 2
  end
end
