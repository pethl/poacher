json.extract! contact, :id, :business_name, :contact_name, :reference, :email, :mobile, :phone, :country, :address, :notes, :created_at, :updated_at
json.url contact_url(contact, format: :json)
