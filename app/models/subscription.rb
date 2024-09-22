class Subscription < ApplicationRecord
  def self.ransackable_attributes(_auth_object = nil)
    %w[publisher_id subscriber_id start_date end_date plan_id id created_at updated_at]
  end
  belongs_to :publisher
  belongs_to :subscriber
  belongs_to :plan
end
