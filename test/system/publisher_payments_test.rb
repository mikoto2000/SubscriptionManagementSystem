require "application_system_test_case"

class PublisherPaymentsTest < ApplicationSystemTestCase
  setup do
    @publisher_payment = publisher_payments(:one)
  end

  test "visiting the index" do
    visit publisher_payments_url
    assert_selector "h1", text: "Publisher payments"
  end

  test "should create publisher payment" do
    visit publisher_payments_url
    click_on "New publisher payment"

    fill_in "Month for payment", with: @publisher_payment.month_for_payment
    fill_in "Payment date", with: @publisher_payment.payment_date
    fill_in "Payment status", with: @publisher_payment.payment_status_id
    fill_in "Publisher", with: @publisher_payment.publisher_id
    click_on "Create Publisher payment"

    assert_text "Publisher payment was successfully created"
    click_on "Back"
  end

  test "should update Publisher payment" do
    visit publisher_payment_url(@publisher_payment)
    click_on "Edit this publisher payment", match: :first

    fill_in "Month for payment", with: @publisher_payment.month_for_payment
    fill_in "Payment date", with: @publisher_payment.payment_date
    fill_in "Payment status", with: @publisher_payment.payment_status_id
    fill_in "Publisher", with: @publisher_payment.publisher_id
    click_on "Update Publisher payment"

    assert_text "Publisher payment was successfully updated"
    click_on "Back"
  end

  test "should destroy Publisher payment" do
    visit publisher_payment_url(@publisher_payment)
    click_on "Destroy this publisher payment", match: :first

    assert_text "Publisher payment was successfully destroyed"
  end
end
