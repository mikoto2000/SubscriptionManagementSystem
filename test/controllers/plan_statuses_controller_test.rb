require "test_helper"

class PlanStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @plan_status = plan_statuses(:one)
  end

  test "should get index" do
    get plan_statuses_url
    assert_response :success
  end

  test "should get index find by id" do
    get plan_statuses_url, params: { q: { id_eq: @plan_status.id } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr:nth-of-type(1) > td", text: @plan_status.id.to_s
  end
  test "should get index search name" do
    search_string = @plan_status.name
    get plan_statuses_url, params: { q: { name_cont: search_string } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: search_string # one
  end

  test "should get index search name, multi hit" do
    search_string = "o" # `o`ne, tw`o`, destr`o`y_target.
    get plan_statuses_url, params: { q: { name_cont: search_string } }
    assert_response :success

    assert_select "table > tbody > tr", count: 3
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: plan_statuses(:one).name # one
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: plan_statuses(:two).name # two
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: plan_statuses(:destroy_target).name # destroy_target
  end

  test "should get index search created_at single hit" do
    target_datetime = @plan_status.created_at
    get plan_statuses_url, params: { q: {
      created_at_gteq: target_datetime,
      created_at_lteq_end_of_minute: target_datetime
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: I18n.l(target_datetime) # one
  end

  test "should get index search created_at, multi hit" do
    target_datetime_from = plan_statuses(:one).created_at
    target_datetime_to = plan_statuses(:two).created_at
    get plan_statuses_url, params: { q: {
      created_at_gteq: target_datetime_from,
      created_at_lteq_end_of_minute: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: I18n.l(target_datetime_from) # one
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: I18n.l(target_datetime_to) # two
  end

  test "should get index search updated_at" do
    target_datetime = @plan_status.updated_at
    get plan_statuses_url, params: { q: {
      updated_at_gteq: target_datetime,
      updated_at_lteq_end_of_minute: target_datetime
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: I18n.l(target_datetime) # one
  end

  test "should get index search updated_at, multi hit" do
    target_datetime_from = plan_statuses(:one).updated_at
    target_datetime_to = plan_statuses(:two).updated_at
    get plan_statuses_url, params: { q: {
      updated_at_gteq: target_datetime_from,
      updated_at_lteq_end_of_minute: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: I18n.l(target_datetime_from) # one
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: I18n.l(target_datetime_to) # two
  end

  test "should get new" do
    get new_plan_status_url
    assert_response :success
  end

  test "should create plan_status" do
    assert_difference("PlanStatus.count") do
      post plan_statuses_url, params: { plan_status:
        { name: @plan_status.name }
       }
    end

    assert_redirected_to plan_status_url(PlanStatus.last)
  end

  test "should show plan_status" do
    get plan_status_url(@plan_status)
    assert_response :success
  end

  test "should get edit" do
    get edit_plan_status_url(@plan_status)
    assert_response :success
  end

  test "should update plan_status" do
    patch plan_status_url(@plan_status), params: { plan_status:
      { name: @plan_status.name }
     }
    assert_redirected_to plan_status_url(@plan_status)
  end

  test "should destroy plan_status" do
    plan_status = plan_statuses(:destroy_target)
    assert_difference("PlanStatus.count", -1) do
      delete plan_status_url(plan_status)
    end

    assert_redirected_to plan_statuses_url
  end
end
