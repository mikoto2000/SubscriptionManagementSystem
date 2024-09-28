class AccountController < ApplicationController
  def index
    @account = current_account
    @publish_plans = Plan.where(publisher_id: @account.publisher_id)
    subscriptions = Subscription
      .where(subscriber_id: @account.subscriber_id)
      .eager_load(:plan)
    pp subscriptions
    @subscribe_plans = subscriptions.map {|subscription|
        subscription.plan
      }
    pp @subscribe_plans
  end
end
