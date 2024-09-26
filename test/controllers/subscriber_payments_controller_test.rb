require "test_helper"

class SubscriberPaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @subscriber_payment = subscriber_payments(:one)
  end

  test "should get index" do
    get subscriber_payments_url
    assert_response :success
  end

  test "should get index find by id" do
    get subscriber_payments_url, params: { q: { id_eq: @subscriber_payment.id } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr:nth-of-type(1) > td", text: @subscriber_payment.id.to_s
  end
  test "should get index search month_for_payment" do
    target_date = @subscriber_payment.month_for_payment
    get subscriber_payments_url, params: { q: {
      month_for_payment_gteq: target_date,
      month_for_payment_lteq_end_of_day: target_date
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: I18n.l(target_date) # one
  end

  test "should get index search month_for_payment, multi hit" do
    target_datetime_from = subscriber_payments(:one).month_for_payment
    target_datetime_to = subscriber_payments(:two).month_for_payment
    get subscriber_payments_url, params: { q: {
      month_for_payment_gteq: target_datetime_from,
      month_for_payment_lteq_end_of_day: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: I18n.l(target_datetime_from) # one
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: I18n.l(target_datetime_to) # two
  end

  test "should get index search month_for_payment, no hit" do
    target_datetime_from = Time.at(0, in: "UTC")
    target_datetime_to = Time.at(0, in: "UTC")
    get subscriber_payments_url, params: { q: {
      month_for_payment_gteq: target_datetime_from,
      month_for_payment_lteq_end_of_day: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 0
  end
  test "should get index search payment_date" do
    target_date = @subscriber_payment.payment_date
    get subscriber_payments_url, params: { q: {
      payment_date_gteq: target_date,
      payment_date_lteq_end_of_day: target_date
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: I18n.l(target_date) # one
  end

  test "should get index search payment_date, multi hit" do
    target_datetime_from = subscriber_payments(:one).payment_date
    target_datetime_to = subscriber_payments(:two).payment_date
    get subscriber_payments_url, params: { q: {
      payment_date_gteq: target_datetime_from,
      payment_date_lteq_end_of_day: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: I18n.l(target_datetime_from) # one
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: I18n.l(target_datetime_to) # two
  end

  test "should get index search payment_date, no hit" do
    target_datetime_from = Time.at(0, in: "UTC")
    target_datetime_to = Time.at(0, in: "UTC")
    get subscriber_payments_url, params: { q: {
      payment_date_gteq: target_datetime_from,
      payment_date_lteq_end_of_day: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 0
  end
  test "should get index search payment_statuss" do
    search_ids = [subscriber_payments(:one).payment_status, subscriber_payments(:two).payment_status]
    get subscriber_payments_url, params: { q: { payment_status_id_in: search_ids } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: @subscriber_payment.payment_status.name # one
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: @subscriber_payment.payment_status.name # two
  end
  test "should get index search subscribers" do
    search_ids = [subscriber_payments(:one).subscriber, subscriber_payments(:two).subscriber]
    get subscriber_payments_url, params: { q: { subscriber_id_in: search_ids } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(5)", text: @subscriber_payment.subscriber.name # one
    assert_select "table > tbody > tr > td:nth-of-type(5)", text: @subscriber_payment.subscriber.name # two
  end

  test "should get index search created_at single hit" do
    target_datetime = @subscriber_payment.created_at
    get subscriber_payments_url, params: { q: {
      created_at_gteq: target_datetime,
      created_at_lteq_end_of_minute: target_datetime
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(6)", text: I18n.l(target_datetime) # one
  end

  test "should get index search created_at, multi hit" do
    target_datetime_from = subscriber_payments(:one).created_at
    target_datetime_to = subscriber_payments(:two).created_at
    get subscriber_payments_url, params: { q: {
      created_at_gteq: target_datetime_from,
      created_at_lteq_end_of_minute: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(6)", text: I18n.l(target_datetime_from) # one
    assert_select "table > tbody > tr > td:nth-of-type(6)", text: I18n.l(target_datetime_to) # two
  end

  test "should get index search updated_at" do
    target_datetime = @subscriber_payment.updated_at
    get subscriber_payments_url, params: { q: {
      updated_at_gteq: target_datetime,
      updated_at_lteq_end_of_minute: target_datetime
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(7)", text: I18n.l(target_datetime) # one
  end

  test "should get index search updated_at, multi hit" do
    target_datetime_from = subscriber_payments(:one).updated_at
    target_datetime_to = subscriber_payments(:two).updated_at
    get subscriber_payments_url, params: { q: {
      updated_at_gteq: target_datetime_from,
      updated_at_lteq_end_of_minute: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(7)", text: I18n.l(target_datetime_from) # one
    assert_select "table > tbody > tr > td:nth-of-type(7)", text: I18n.l(target_datetime_to) # two
  end

  test "should get new" do
    get new_subscriber_payment_url
    assert_response :success
  end

  test "should create subscriber_payment" do
    assert_difference("SubscriberPayment.count") do
      post subscriber_payments_url, params: { subscriber_payment:
        { month_for_payment: @subscriber_payment.month_for_payment, payment_date: @subscriber_payment.payment_date, payment_status_id: @subscriber_payment.payment_status_id, subscriber_id: @subscriber_payment.subscriber_id }
       }
    end

    assert_redirected_to subscriber_payment_url(SubscriberPayment.last)
  end

  test "should show subscriber_payment" do
    get subscriber_payment_url(@subscriber_payment)
    assert_response :success
  end

  test "should get edit" do
    get edit_subscriber_payment_url(@subscriber_payment)
    assert_response :success
  end

  test "should update subscriber_payment" do
    patch subscriber_payment_url(@subscriber_payment), params: { subscriber_payment:
      { month_for_payment: @subscriber_payment.month_for_payment, payment_date: @subscriber_payment.payment_date, payment_status_id: @subscriber_payment.payment_status_id, subscriber_id: @subscriber_payment.subscriber_id }
     }
    assert_redirected_to subscriber_payment_url(@subscriber_payment)
  end

  test "should destroy subscriber_payment" do
    subscriber_payment = subscriber_payments(:destroy_target)
    assert_difference("SubscriberPayment.count", -1) do
      delete subscriber_payment_url(subscriber_payment)
    end

    assert_redirected_to subscriber_payments_url
  end
end
