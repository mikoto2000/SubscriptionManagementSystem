class Payment < ApplicationRecord
  def self.ransackable_attributes(_auth_object = nil)
    %w[type month_for_payment payment_date payment_status_id publisher_id subscriber_id id created_at updated_at]
  end

  validates :month_for_payment, presence: true

  belongs_to :payment_status
  belongs_to :publisher, optional: true
  belongs_to :subscriber, optional: true
end
