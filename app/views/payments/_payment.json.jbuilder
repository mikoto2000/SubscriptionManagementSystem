json.extract! payment, :id, :year, :month, :payment_date, :payment_status_id, :account_id, :created_at, :updated_at
json.url payment_url(payment, format: :json)
