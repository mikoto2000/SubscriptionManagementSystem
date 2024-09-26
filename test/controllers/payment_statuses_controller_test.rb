require "test_helper"

class PaymentStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @payment_status = payment_statuses(:one)
  end

  test "should get index" do
    get payment_statuses_url
    assert_response :success
  end

  test "should get index find by id" do
    get payment_statuses_url, params: { q: { id_eq: @payment_status.id } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr:nth-of-type(1) > td", text: @payment_status.id.to_s
  end
  test "should get index search name" do
    search_string = @payment_status.name
    get payment_statuses_url, params: { q: { name_cont: search_string } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: search_string # one
  end

  test "should get index search name, multi hit" do
    search_string = "o" # `o`ne, tw`o`, destr`o`y_target.
    get payment_statuses_url, params: { q: { name_cont: search_string } }
    assert_response :success

    assert_select "table > tbody > tr", count: 3
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: payment_statuses(:one).name # one
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: payment_statuses(:two).name # two
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: payment_statuses(:destroy_target).name # destroy_target
  end

  test "should get index search created_at single hit" do
    target_datetime = @payment_status.created_at
    get payment_statuses_url, params: { q: {
      created_at_gteq: target_datetime,
      created_at_lteq_end_of_minute: target_datetime
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: I18n.l(target_datetime) # one
  end

  test "should get index search created_at, multi hit" do
    target_datetime_from = payment_statuses(:one).created_at
    target_datetime_to = payment_statuses(:two).created_at
    get payment_statuses_url, params: { q: {
      created_at_gteq: target_datetime_from,
      created_at_lteq_end_of_minute: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: I18n.l(target_datetime_from) # one
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: I18n.l(target_datetime_to) # two
  end

  test "should get index search updated_at" do
    target_datetime = @payment_status.updated_at
    get payment_statuses_url, params: { q: {
      updated_at_gteq: target_datetime,
      updated_at_lteq_end_of_minute: target_datetime
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: I18n.l(target_datetime) # one
  end

  test "should get index search updated_at, multi hit" do
    target_datetime_from = payment_statuses(:one).updated_at
    target_datetime_to = payment_statuses(:two).updated_at
    get payment_statuses_url, params: { q: {
      updated_at_gteq: target_datetime_from,
      updated_at_lteq_end_of_minute: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: I18n.l(target_datetime_from) # one
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: I18n.l(target_datetime_to) # two
  end

  test "should get new" do
    get new_payment_status_url
    assert_response :success
  end

  test "should create payment_status" do
    assert_difference("PaymentStatus.count") do
      post payment_statuses_url, params: { payment_status:
        { name: @payment_status.name }
       }
    end

    assert_redirected_to payment_status_url(PaymentStatus.last)
  end

  test "should show payment_status" do
    get payment_status_url(@payment_status)
    assert_response :success
  end

  test "should get edit" do
    get edit_payment_status_url(@payment_status)
    assert_response :success
  end

  test "should update payment_status" do
    patch payment_status_url(@payment_status), params: { payment_status:
      { name: @payment_status.name }
     }
    assert_redirected_to payment_status_url(@payment_status)
  end

  test "should destroy payment_status" do
    payment_status = payment_statuses(:destroy_target)
    assert_difference("PaymentStatus.count", -1) do
      delete payment_status_url(payment_status)
    end

    assert_redirected_to payment_statuses_url
  end
end
