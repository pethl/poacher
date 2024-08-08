json.extract! picksheet, :id, :date_order_placed, :delivery_required_by, :order_number, :contact_telephone_number, :invoice_number, :carrier, :carrier_delivery_date, :number_of_boxes, :created_at, :updated_at
json.url picksheet_url(picksheet, format: :json)
