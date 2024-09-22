require "test_helper"

class PlansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @plan = plans(:one)
  end

  test "should get index" do
    get plans_url
    assert_response :success
  end

  test "should get index find by id" do
    get plans_url, params: { q: { id_eq: @plan.id } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr:nth-of-type(1) > td", text: @plan.id.to_s
  end
  test "should get index search publishers" do
    search_ids = [plans(:one).publisher, plans(:two).publisher]
    get plans_url, params: { q: { publisher_id_in: search_ids } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: @plan.publisher.name # one
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: @plan.publisher.name # two
  end
  test "should get index search name" do
    search_string = @plan.name
    get plans_url, params: { q: { name_cont: search_string } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: search_string # one
  end

  test "should get index search name, multi hit" do
    search_string = "o" # `o`ne, tw`o`, destr`o`y_target.
    get plans_url, params: { q: { name_cont: search_string } }
    assert_response :success

    assert_select "table > tbody > tr", count: 3
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: plans(:one).name # one
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: plans(:two).name # two
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: plans(:destroy_target).name # destroy_target
  end
  test "should get index search cost" do
    search_string = @plan.cost
    get plans_url, params: { q: { cost_cont: search_string } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: search_string # one
  end

  test "should get index search cost, multi hit" do
    search_string = "o" # `o`ne, tw`o`, destr`o`y_target.
    get plans_url, params: { q: { cost_cont: search_string } }
    assert_response :success

    assert_select "table > tbody > tr", count: 3
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: plans(:one).name # one
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: plans(:two).name # two
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: plans(:destroy_target).name # destroy_target
  end

  test "should get index search created_at single hit" do
    target_datetime = @plan.created_at
    get plans_url, params: { q: {
      created_at_gteq: target_datetime,
      created_at_lteq_end_of_minute: target_datetime
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(5)", text: I18n.l(target_datetime) # one
  end

  test "should get index search created_at, multi hit" do
    target_datetime_from = plans(:one).created_at
    target_datetime_to = plans(:two).created_at
    get plans_url, params: { q: {
      created_at_gteq: target_datetime_from,
      created_at_lteq_end_of_minute: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(5)", text: I18n.l(target_datetime_from) # one
    assert_select "table > tbody > tr > td:nth-of-type(5)", text: I18n.l(target_datetime_to) # two
  end

  test "should get index search updated_at" do
    target_datetime = @plan.updated_at
    get plans_url, params: { q: {
      updated_at_gteq: target_datetime,
      updated_at_lteq_end_of_minute: target_datetime
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(6)", text: I18n.l(target_datetime) # one
  end

  test "should get index search updated_at, multi hit" do
    target_datetime_from = plans(:one).updated_at
    target_datetime_to = plans(:two).updated_at
    get plans_url, params: { q: {
      updated_at_gteq: target_datetime_from,
      updated_at_lteq_end_of_minute: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(6)", text: I18n.l(target_datetime_from) # one
    assert_select "table > tbody > tr > td:nth-of-type(6)", text: I18n.l(target_datetime_to) # two
  end

  test "should get new" do
    get new_plan_url
    assert_response :success
  end

  test "should create plan" do
    assert_difference("Plan.count") do
      post plans_url, params: { plan:
        { cost: @plan.cost, name: @plan.name, publisher_id: @plan.publisher_id }
       }
    end

    assert_redirected_to plan_url(Plan.last)
  end

  test "should show plan" do
    get plan_url(@plan)
    assert_response :success
  end

  test "should get edit" do
    get edit_plan_url(@plan)
    assert_response :success
  end

  test "should update plan" do
    patch plan_url(@plan), params: { plan:
      { cost: @plan.cost, name: @plan.name, publisher_id: @plan.publisher_id }
     }
    assert_redirected_to plan_url(@plan)
  end

  test "should destroy plan" do
    plan = plans(:destroy_target)
    assert_difference("Plan.count", -1) do
      delete plan_url(plan)
    end

    assert_redirected_to plans_url
  end
end
