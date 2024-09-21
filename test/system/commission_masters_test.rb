require "application_system_test_case"

class CommissionMastersTest < ApplicationSystemTestCase
  setup do
    @commission_master = commission_masters(:one)
  end

  test "visiting the index" do
    visit commission_masters_url
    assert_selector "h1", text: "Commission masters"
  end

  test "should create commission master" do
    visit commission_masters_url
    click_on "New commission master"

    fill_in "Commission fee", with: @commission_master.commission_fee
    fill_in "From date", with: @commission_master.from_date
    fill_in "To date", with: @commission_master.to_date
    click_on "Create Commission master"

    assert_text "Commission master was successfully created"
    click_on "Back"
  end

  test "should update Commission master" do
    visit commission_master_url(@commission_master)
    click_on "Edit this commission master", match: :first

    fill_in "Commission fee", with: @commission_master.commission_fee
    fill_in "From date", with: @commission_master.from_date
    fill_in "To date", with: @commission_master.to_date
    click_on "Update Commission master"

    assert_text "Commission master was successfully updated"
    click_on "Back"
  end

  test "should destroy Commission master" do
    visit commission_master_url(@commission_master)
    click_on "Destroy this commission master", match: :first

    assert_text "Commission master was successfully destroyed"
  end
end
