json.extract! subscription, :id, :publisher_id, :subscriber_id, :start_date, :end_date, :plan_id, :created_at, :updated_at
json.url subscription_url(subscription, format: :json)
