class HomeController < ApplicationController
  def index
    @publish_plans = Plan.where(publisher_id: current_account.publisher_id)
    @subscribe_subscriptions = Subscription
      .where(subscriber_id: current_account.subscriber_id)
      .where("end_date >= ?", Time.zone.today.beginning_of_month)
      .or(
        Subscription.where(subscriber_id: current_account.subscriber_id)
        .where(end_date: nil)
      )
      .eager_load(:plan)
  end

  def create_plan
    @publish_plans = Plan.where(publisher_id: current_account.publisher_id)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
