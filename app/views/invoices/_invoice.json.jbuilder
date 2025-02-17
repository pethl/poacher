json.extract! invoice, :id, :number, :account, :date, :amount, :weight, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)
