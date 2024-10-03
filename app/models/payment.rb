class Payment < ApplicationRecord
  def self.ransackable_associations(auth_object = nil)
    ["account", "payment_status", "publisher", "subscriber"]
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[year month payment_date payment_status_id publisher_id subscriber_id id created_at updated_at account]
  end

  def all_subscription_plan
    Payment.all
      .eager_load(account: { subscriber: { subscription: :plan }})
      .find(self.account.subscriber_id)
      .account
      .subscriber
      .subscription.map {|e|
        e.plan
      }
  end

  def all_subscription_cost
    all_subscription_plan.map {|e|
        e.cost
      }
      .sum
  end

  def all_publish_plan
    Payment.all
      .eager_load(account: { publisher: { subscription: :plan }})
      .find(self.account.publisher_id)
      .account
      .publisher
      .subscription.map {|e|
        e.plan
      }
  end

  def all_publish_cost
    all_publish_plan.map {|e|
        e.cost
      }
      .sum
  end

  def all_publish_fee
    all_publish_plan.map {|e|
        e.cost
      }
      # TODO: 期間で絞る
      .sum * CommissionMaster.find(1).commission_fee
  end

  validates :year, presence: true
  validates :month, presence: true
  validates :payment_date, presence: true

  belongs_to :payment_status
  belongs_to :account
end
