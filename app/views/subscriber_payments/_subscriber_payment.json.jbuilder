json.extract! subscriber_payment, :id, :month_for_payment, :payment_date, :payment_status_id, :subscriber_id, :created_at, :updated_at
json.url subscriber_payment_url(subscriber_payment, format: :json)
