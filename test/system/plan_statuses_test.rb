require "application_system_test_case"

class PlanStatusesTest < ApplicationSystemTestCase
  setup do
    @plan_status = plan_statuses(:one)
  end

  test "visiting the index" do
    visit plan_statuses_url
    assert_selector "h1", text: "Plan statuses"
  end

  test "should create plan status" do
    visit plan_statuses_url
    click_on "New plan status"

    fill_in "Name", with: @plan_status.name
    click_on "Create Plan status"

    assert_text "Plan status was successfully created"
    click_on "Back"
  end

  test "should update Plan status" do
    visit plan_status_url(@plan_status)
    click_on "Edit this plan status", match: :first

    fill_in "Name", with: @plan_status.name
    click_on "Update Plan status"

    assert_text "Plan status was successfully updated"
    click_on "Back"
  end

  test "should destroy Plan status" do
    visit plan_status_url(@plan_status)
    click_on "Destroy this plan status", match: :first

    assert_text "Plan status was successfully destroyed"
  end
end
