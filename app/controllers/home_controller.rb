class HomeController < ApplicationController
  def index
    @publish_plans = Plan.where(publisher_id: current_account.publisher_id)
    subscriptions = Subscription
      .where(subscriber_id: current_account.subscriber_id)
      .eager_load(:plan)
    @subscribe_plans = subscriptions.map {|subscription|
      subscription.plan
    }
  end
end
