require "test_helper"

class SubscriptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @subscription = subscriptions(:one)
  end

  test "should get index" do
    get subscriptions_url
    assert_response :success
  end

  test "should get index find by id" do
    get subscriptions_url, params: { q: { id_eq: @subscription.id } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr:nth-of-type(1) > td", text: @subscription.id.to_s
  end
  test "should get index search publishers" do
    search_ids = [subscriptions(:one).publisher, subscriptions(:two).publisher]
    get subscriptions_url, params: { q: { publisher_id_in: search_ids } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: @subscription.publisher.name # one
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: @subscription.publisher.name # two
  end
  test "should get index search subscribers" do
    search_ids = [subscriptions(:one).subscriber, subscriptions(:two).subscriber]
    get subscriptions_url, params: { q: { subscriber_id_in: search_ids } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: @subscription.subscriber.name # one
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: @subscription.subscriber.name # two
  end
  test "should get index search start_date" do
    target_date = @subscription.start_date
    get subscriptions_url, params: { q: {
      start_date_gteq: target_date,
      start_date_lteq_end_of_day: target_date
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: I18n.l(target_date) # one
  end

  test "should get index search start_date, multi hit" do
    target_datetime_from = subscriptions(:one).start_date
    target_datetime_to = subscriptions(:two).start_date
    get subscriptions_url, params: { q: {
      start_date_gteq: target_datetime_from,
      start_date_lteq_end_of_day: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: I18n.l(target_datetime_from) # one
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: I18n.l(target_datetime_to) # two
  end

  test "should get index search start_date, no hit" do
    target_datetime_from = Time.at(0, in: "UTC")
    target_datetime_to = Time.at(0, in: "UTC")
    get subscriptions_url, params: { q: {
      start_date_gteq: target_datetime_from,
      start_date_lteq_end_of_day: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 0
  end
  test "should get index search end_date" do
    target_date = @subscription.end_date
    get subscriptions_url, params: { q: {
      end_date_gteq: target_date,
      end_date_lteq_end_of_day: target_date
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(5)", text: I18n.l(target_date) # one
  end

  test "should get index search end_date, multi hit" do
    target_datetime_from = subscriptions(:one).end_date
    target_datetime_to = subscriptions(:two).end_date
    get subscriptions_url, params: { q: {
      end_date_gteq: target_datetime_from,
      end_date_lteq_end_of_day: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(5)", text: I18n.l(target_datetime_from) # one
    assert_select "table > tbody > tr > td:nth-of-type(5)", text: I18n.l(target_datetime_to) # two
  end

  test "should get index search end_date, no hit" do
    target_datetime_from = Time.at(0, in: "UTC")
    target_datetime_to = Time.at(0, in: "UTC")
    get subscriptions_url, params: { q: {
      end_date_gteq: target_datetime_from,
      end_date_lteq_end_of_day: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 0
  end
  test "should get index search plans" do
    search_ids = [subscriptions(:one).plan, subscriptions(:two).plan]
    get subscriptions_url, params: { q: { plan_id_in: search_ids } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(6)", text: @subscription.plan.name # one
    assert_select "table > tbody > tr > td:nth-of-type(6)", text: @subscription.plan.name # two
  end

  test "should get index search created_at single hit" do
    target_datetime = @subscription.created_at
    get subscriptions_url, params: { q: {
      created_at_gteq: target_datetime,
      created_at_lteq_end_of_minute: target_datetime
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(7)", text: I18n.l(target_datetime) # one
  end

  test "should get index search created_at, multi hit" do
    target_datetime_from = subscriptions(:one).created_at
    target_datetime_to = subscriptions(:two).created_at
    get subscriptions_url, params: { q: {
      created_at_gteq: target_datetime_from,
      created_at_lteq_end_of_minute: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(7)", text: I18n.l(target_datetime_from) # one
    assert_select "table > tbody > tr > td:nth-of-type(7)", text: I18n.l(target_datetime_to) # two
  end

  test "should get index search updated_at" do
    target_datetime = @subscription.updated_at
    get subscriptions_url, params: { q: {
      updated_at_gteq: target_datetime,
      updated_at_lteq_end_of_minute: target_datetime
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(8)", text: I18n.l(target_datetime) # one
  end

  test "should get index search updated_at, multi hit" do
    target_datetime_from = subscriptions(:one).updated_at
    target_datetime_to = subscriptions(:two).updated_at
    get subscriptions_url, params: { q: {
      updated_at_gteq: target_datetime_from,
      updated_at_lteq_end_of_minute: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(8)", text: I18n.l(target_datetime_from) # one
    assert_select "table > tbody > tr > td:nth-of-type(8)", text: I18n.l(target_datetime_to) # two
  end

  test "should get new" do
    get new_subscription_url
    assert_response :success
  end

  test "should create subscription" do
    assert_difference("Subscription.count") do
      post subscriptions_url, params: { subscription:
        { end_date: @subscription.end_date, plan_id: @subscription.plan_id, publisher_id: @subscription.publisher_id, start_date: @subscription.start_date, subscriber_id: @subscription.subscriber_id }
       }
    end

    assert_redirected_to subscription_url(Subscription.last)
  end

  test "should show subscription" do
    get subscription_url(@subscription)
    assert_response :success
  end

  test "should get edit" do
    get edit_subscription_url(@subscription)
    assert_response :success
  end

  test "should update subscription" do
    patch subscription_url(@subscription), params: { subscription:
      { end_date: @subscription.end_date, plan_id: @subscription.plan_id, publisher_id: @subscription.publisher_id, start_date: @subscription.start_date, subscriber_id: @subscription.subscriber_id }
     }
    assert_redirected_to subscription_url(@subscription)
  end

  test "should destroy subscription" do
    subscription = subscriptions(:destroy_target)
    assert_difference("Subscription.count", -1) do
      delete subscription_url(subscription)
    end

    assert_redirected_to subscriptions_url
  end
end
