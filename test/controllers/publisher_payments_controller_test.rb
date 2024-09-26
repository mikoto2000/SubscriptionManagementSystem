require "test_helper"

class PublisherPaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @publisher_payment = publisher_payments(:one)
  end

  test "should get index" do
    get publisher_payments_url
    assert_response :success
  end

  test "should get index find by id" do
    get publisher_payments_url, params: { q: { id_eq: @publisher_payment.id } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr:nth-of-type(1) > td", text: @publisher_payment.id.to_s
  end
  test "should get index search month_for_payment" do
    target_date = @publisher_payment.month_for_payment
    get publisher_payments_url, params: { q: {
      month_for_payment_gteq: target_date,
      month_for_payment_lteq_end_of_day: target_date
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: I18n.l(target_date) # one
  end

  test "should get index search month_for_payment, multi hit" do
    target_datetime_from = publisher_payments(:one).month_for_payment
    target_datetime_to = publisher_payments(:two).month_for_payment
    get publisher_payments_url, params: { q: {
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
    get publisher_payments_url, params: { q: {
      month_for_payment_gteq: target_datetime_from,
      month_for_payment_lteq_end_of_day: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 0
  end
  test "should get index search payment_date" do
    target_date = @publisher_payment.payment_date
    get publisher_payments_url, params: { q: {
      payment_date_gteq: target_date,
      payment_date_lteq_end_of_day: target_date
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: I18n.l(target_date) # one
  end

  test "should get index search payment_date, multi hit" do
    target_datetime_from = publisher_payments(:one).payment_date
    target_datetime_to = publisher_payments(:two).payment_date
    get publisher_payments_url, params: { q: {
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
    get publisher_payments_url, params: { q: {
      payment_date_gteq: target_datetime_from,
      payment_date_lteq_end_of_day: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 0
  end
  test "should get index search payment_statuss" do
    search_ids = [publisher_payments(:one).payment_status, publisher_payments(:two).payment_status]
    get publisher_payments_url, params: { q: { payment_status_id_in: search_ids } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: @publisher_payment.payment_status.name # one
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: @publisher_payment.payment_status.name # two
  end
  test "should get index search publishers" do
    search_ids = [publisher_payments(:one).publisher, publisher_payments(:two).publisher]
    get publisher_payments_url, params: { q: { publisher_id_in: search_ids } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(5)", text: @publisher_payment.publisher.name # one
    assert_select "table > tbody > tr > td:nth-of-type(5)", text: @publisher_payment.publisher.name # two
  end

  test "should get index search created_at single hit" do
    target_datetime = @publisher_payment.created_at
    get publisher_payments_url, params: { q: {
      created_at_gteq: target_datetime,
      created_at_lteq_end_of_minute: target_datetime
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(6)", text: I18n.l(target_datetime) # one
  end

  test "should get index search created_at, multi hit" do
    target_datetime_from = publisher_payments(:one).created_at
    target_datetime_to = publisher_payments(:two).created_at
    get publisher_payments_url, params: { q: {
      created_at_gteq: target_datetime_from,
      created_at_lteq_end_of_minute: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(6)", text: I18n.l(target_datetime_from) # one
    assert_select "table > tbody > tr > td:nth-of-type(6)", text: I18n.l(target_datetime_to) # two
  end

  test "should get index search updated_at" do
    target_datetime = @publisher_payment.updated_at
    get publisher_payments_url, params: { q: {
      updated_at_gteq: target_datetime,
      updated_at_lteq_end_of_minute: target_datetime
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(7)", text: I18n.l(target_datetime) # one
  end

  test "should get index search updated_at, multi hit" do
    target_datetime_from = publisher_payments(:one).updated_at
    target_datetime_to = publisher_payments(:two).updated_at
    get publisher_payments_url, params: { q: {
      updated_at_gteq: target_datetime_from,
      updated_at_lteq_end_of_minute: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(7)", text: I18n.l(target_datetime_from) # one
    assert_select "table > tbody > tr > td:nth-of-type(7)", text: I18n.l(target_datetime_to) # two
  end

  test "should get new" do
    get new_publisher_payment_url
    assert_response :success
  end

  test "should create publisher_payment" do
    assert_difference("PublisherPayment.count") do
      post publisher_payments_url, params: { publisher_payment:
        { month_for_payment: @publisher_payment.month_for_payment, payment_date: @publisher_payment.payment_date, payment_status_id: @publisher_payment.payment_status_id, publisher_id: @publisher_payment.publisher_id }
       }
    end

    assert_redirected_to publisher_payment_url(PublisherPayment.last)
  end

  test "should show publisher_payment" do
    get publisher_payment_url(@publisher_payment)
    assert_response :success
  end

  test "should get edit" do
    get edit_publisher_payment_url(@publisher_payment)
    assert_response :success
  end

  test "should update publisher_payment" do
    patch publisher_payment_url(@publisher_payment), params: { publisher_payment:
      { month_for_payment: @publisher_payment.month_for_payment, payment_date: @publisher_payment.payment_date, payment_status_id: @publisher_payment.payment_status_id, publisher_id: @publisher_payment.publisher_id }
     }
    assert_redirected_to publisher_payment_url(@publisher_payment)
  end

  test "should destroy publisher_payment" do
    publisher_payment = publisher_payments(:destroy_target)
    assert_difference("PublisherPayment.count", -1) do
      delete publisher_payment_url(publisher_payment)
    end

    assert_redirected_to publisher_payments_url
  end
end
