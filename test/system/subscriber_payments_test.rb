require "application_system_test_case"

class SubscriberPaymentsTest < ApplicationSystemTestCase
  setup do
    @subscriber_payment = subscriber_payments(:one)
  end

  test "visiting the index" do
    visit subscriber_payments_url
    assert_selector "h1", text: "Subscriber payments"
  end

  test "should create subscriber payment" do
    visit subscriber_payments_url
    click_on "New subscriber payment"

    fill_in "Month for payment", with: @subscriber_payment.month_for_payment
    fill_in "Payment date", with: @subscriber_payment.payment_date
    fill_in "Payment status", with: @subscriber_payment.payment_status_id
    fill_in "Subscriber", with: @subscriber_payment.subscriber_id
    click_on "Create Subscriber payment"

    assert_text "Subscriber payment was successfully created"
    click_on "Back"
  end

  test "should update Subscriber payment" do
    visit subscriber_payment_url(@subscriber_payment)
    click_on "Edit this subscriber payment", match: :first

    fill_in "Month for payment", with: @subscriber_payment.month_for_payment
    fill_in "Payment date", with: @subscriber_payment.payment_date
    fill_in "Payment status", with: @subscriber_payment.payment_status_id
    fill_in "Subscriber", with: @subscriber_payment.subscriber_id
    click_on "Update Subscriber payment"

    assert_text "Subscriber payment was successfully updated"
    click_on "Back"
  end

  test "should destroy Subscriber payment" do
    visit subscriber_payment_url(@subscriber_payment)
    click_on "Destroy this subscriber payment", match: :first

    assert_text "Subscriber payment was successfully destroyed"
  end
end
