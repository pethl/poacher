json.extract! delivery_inspection, :id, :delivery_date, :item, :batch_no, :best_before, :cert_received, :damage, :foreign_contam, :pest_contam, :timely_delivery, :satisfactory, :comments, :staff_id, :staff_signature, :created_at, :updated_at
json.url delivery_inspection_url(delivery_inspection, format: :json)
