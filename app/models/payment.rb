class Payment < ApplicationRecord
  def self.ransackable_associations(auth_object = nil)
    ["account", "payment_status", "publisher", "subscriber"]
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[year month payment_date payment_status_id publisher_id subscriber_id id created_at updated_at account]
  end

  def all_subscription_plan target_date

    begin_date = target_date.beginning_of_month
    end_date = target_date.end_of_month

    puts "👺"
    puts self.account.subscriber_id

    payment = Payment.all
      .eager_load(account: { subscriber: { subscription: :plan }})
      .where("subscriptions.start_date <= ? AND (subscriptions.end_date >= ? OR subscriptions.end_date is null)", end_date, begin_date)
      .find_by(account_id: self.account.subscriber_id)

    pp payment

    return [] if payment.nil?

    payment.account
      .subscriber
      .subscription.map {|e|
        e.plan
      }
  end

  def all_subscription_price target_date
    all_subscription_plan(target_date).map {|e|
        e.cost
      }
      .sum
  end

  def all_publish_plan target_date

    begin_date = target_date.beginning_of_month
    end_date = target_date.end_of_month

    payment = Payment.all
      .eager_load(account: { publisher: { subscription: :plan }})
      .where("subscriptions.start_date <= ? AND (subscriptions.end_date >= ? OR subscriptions.end_date is null)", end_date, begin_date)
      .find_by(account_id: self.account.subscriber_id)

    return [] if payment.nil?

    payment.account
      .publisher
      .subscription.map {|e|
        e.plan
      }
  end

  def all_publish_income target_date
    all_publish_plan(target_date).map {|e|
        e.cost
      }
      .sum
  end

  def all_publish_fee target_date
    all_publish_plan(target_date).map {|e|
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
