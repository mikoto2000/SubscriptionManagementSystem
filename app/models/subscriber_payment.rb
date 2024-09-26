class SubscriberPayment < Payment
  def self.ransackable_attributes(_auth_object = nil)
    %w[month_for_payment payment_date payment_status_id subscriber_id id created_at updated_at]
  end
  belongs_to :payment_status
  belongs_to :subscriber
end
