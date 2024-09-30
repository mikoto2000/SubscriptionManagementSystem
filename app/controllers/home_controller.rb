class HomeController < ApplicationController
  def index
    @account = current_account
    @publish_plans = Plan.where(publisher_id: @account.publisher_id)
    subscriptions = Subscription
      .where(subscriber_id: @account.subscriber_id)
      .eager_load(:plan)
    @subscribe_plans = subscriptions.map {|subscription|
      subscription.plan
    }
  end
end
