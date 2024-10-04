json.extract! account, :id, :name, :email_address, :publisher_id, :subscriber_id, :created_at, :updated_at
json.url account_url(account, format: :json)
