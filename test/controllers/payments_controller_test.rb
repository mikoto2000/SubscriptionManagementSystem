require "test_helper"

class PaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @payment = payments(:one)
  end

  test "should get index" do
    get payments_url
    assert_response :success
  end

  test "should get index find by id" do
    get payments_url, params: { q: { id_eq: @payment.id } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr:nth-of-type(1) > td", text: @payment.id.to_s
  end
  test "should get index search year" do
    search_string = @payment.year
    get payments_url, params: { q: { year_cont: search_string } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: search_string # one
  end

  test "should get index search year, multi hit" do
    search_string = "o" # `o`ne, tw`o`, destr`o`y_target.
    get payments_url, params: { q: { year_cont: search_string } }
    assert_response :success

    assert_select "table > tbody > tr", count: 3
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: payments(:one).name # one
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: payments(:two).name # two
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: payments(:destroy_target).name # destroy_target
  end
  test "should get index search mouth" do
    search_string = @payment.mouth
    get payments_url, params: { q: { mouth_cont: search_string } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: search_string # one
  end

  test "should get index search mouth, multi hit" do
    search_string = "o" # `o`ne, tw`o`, destr`o`y_target.
    get payments_url, params: { q: { mouth_cont: search_string } }
    assert_response :success

    assert_select "table > tbody > tr", count: 3
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: payments(:one).name # one
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: payments(:two).name # two
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: payments(:destroy_target).name # destroy_target
  end
  test "should get index search payment_date" do
    target_date = @payment.payment_date
    get payments_url, params: { q: {
      payment_date_gteq: target_date,
      payment_date_lteq_end_of_day: target_date
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: I18n.l(target_date) # one
  end

  test "should get index search payment_date, multi hit" do
    target_datetime_from = payments(:one).payment_date
    target_datetime_to = payments(:two).payment_date
    get payments_url, params: { q: {
      payment_date_gteq: target_datetime_from,
      payment_date_lteq_end_of_day: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: I18n.l(target_datetime_from) # one
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: I18n.l(target_datetime_to) # two
  end

  test "should get index search payment_date, no hit" do
    target_datetime_from = Time.at(0, in: "UTC")
    target_datetime_to = Time.at(0, in: "UTC")
    get payments_url, params: { q: {
      payment_date_gteq: target_datetime_from,
      payment_date_lteq_end_of_day: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 0
  end
  test "should get index search payment_statuss" do
    search_ids = [payments(:one).payment_status, payments(:two).payment_status]
    get payments_url, params: { q: { payment_status_id_in: search_ids } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(5)", text: @payment.payment_status.name # one
    assert_select "table > tbody > tr > td:nth-of-type(5)", text: @payment.payment_status.name # two
  end
  test "should get index search accounts" do
    search_ids = [payments(:one).account, payments(:two).account]
    get payments_url, params: { q: { account_id_in: search_ids } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(6)", text: @payment.account.name # one
    assert_select "table > tbody > tr > td:nth-of-type(6)", text: @payment.account.name # two
  end

  test "should get index search created_at single hit" do
    target_datetime = @payment.created_at
    get payments_url, params: { q: {
      created_at_gteq: target_datetime,
      created_at_lteq_end_of_minute: target_datetime
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(7)", text: I18n.l(target_datetime) # one
  end

  test "should get index search created_at, multi hit" do
    target_datetime_from = payments(:one).created_at
    target_datetime_to = payments(:two).created_at
    get payments_url, params: { q: {
      created_at_gteq: target_datetime_from,
      created_at_lteq_end_of_minute: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(7)", text: I18n.l(target_datetime_from) # one
    assert_select "table > tbody > tr > td:nth-of-type(7)", text: I18n.l(target_datetime_to) # two
  end

  test "should get index search updated_at" do
    target_datetime = @payment.updated_at
    get payments_url, params: { q: {
      updated_at_gteq: target_datetime,
      updated_at_lteq_end_of_minute: target_datetime
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(8)", text: I18n.l(target_datetime) # one
  end

  test "should get index search updated_at, multi hit" do
    target_datetime_from = payments(:one).updated_at
    target_datetime_to = payments(:two).updated_at
    get payments_url, params: { q: {
      updated_at_gteq: target_datetime_from,
      updated_at_lteq_end_of_minute: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(8)", text: I18n.l(target_datetime_from) # one
    assert_select "table > tbody > tr > td:nth-of-type(8)", text: I18n.l(target_datetime_to) # two
  end

  test "should get new" do
    get new_payment_url
    assert_response :success
  end

  test "should create payment" do
    assert_difference("Payment.count") do
      post payments_url, params: { payment:
        { account_id: @payment.account_id, mouth: @payment.mouth, payment_date: @payment.payment_date, payment_status_id: @payment.payment_status_id, year: @payment.year }
       }
    end

    assert_redirected_to payment_url(Payment.last)
  end

  test "should show payment" do
    get payment_url(@payment)
    assert_response :success
  end

  test "should get edit" do
    get edit_payment_url(@payment)
    assert_response :success
  end

  test "should update payment" do
    patch payment_url(@payment), params: { payment:
      { account_id: @payment.account_id, mouth: @payment.mouth, payment_date: @payment.payment_date, payment_status_id: @payment.payment_status_id, year: @payment.year }
     }
    assert_redirected_to payment_url(@payment)
  end

  test "should destroy payment" do
    payment = payments(:destroy_target)
    assert_difference("Payment.count", -1) do
      delete payment_url(payment)
    end

    assert_redirected_to payments_url
  end
end
