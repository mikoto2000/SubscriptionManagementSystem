require "test_helper"

class CommissionMastersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @commission_master = commission_masters(:one)
    @additional_commission_master = CommissionMaster::new({
      :from_date => Date.new(2020,10,10),
      :to_date => Date.new(2020,10,11),
      :commission_fee => 3})
  end

  test "should get index" do
    get commission_masters_url
    assert_response :success
  end

  test "should get index find by id" do
    get commission_masters_url, params: { q: { id_eq: @commission_master.id } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr:nth-of-type(1) > td", text: @commission_master.id.to_s
  end
  test "should get index search from_date" do
    target_date = @commission_master.from_date
    get commission_masters_url, params: { q: {
      from_date_gteq: target_date,
      from_date_lteq_end_of_day: target_date
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: I18n.l(target_date) # one
  end

  test "should get index search from_date, no hit" do
    target_datetime_from = Time.at(0, in: "UTC")
    target_datetime_to = Time.at(0, in: "UTC")
    get commission_masters_url, params: { q: {
      from_date_gteq: target_datetime_from,
      from_date_lteq_end_of_day: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 0
  end
  test "should get index search to_date" do
    target_date = @commission_master.to_date
    get commission_masters_url, params: { q: {
      to_date_gteq: target_date,
      to_date_lteq_end_of_day: target_date
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: I18n.l(target_date) # one
  end

  test "should get index search to_date, no hit" do
    target_datetime_from = Time.at(0, in: "UTC")
    target_datetime_to = Time.at(0, in: "UTC")
    get commission_masters_url, params: { q: {
      to_date_gteq: target_datetime_from,
      to_date_lteq_end_of_day: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 0
  end
  test "should get index search commission_fee" do
    search_string = @commission_master.commission_fee
    get commission_masters_url, params: { q: { commission_fee_eq: search_string } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: search_string.to_s # one
  end

  test "should get index search created_at single hit" do
    target_datetime = @commission_master.created_at
    get commission_masters_url, params: { q: {
      created_at_gteq: target_datetime,
      created_at_lteq_end_of_minute: target_datetime
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(5)", text: I18n.l(target_datetime) # one
  end

  test "should get index search updated_at" do
    target_datetime = @commission_master.updated_at
    get commission_masters_url, params: { q: {
      updated_at_gteq: target_datetime,
      updated_at_lteq_end_of_minute: target_datetime
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(6)", text: I18n.l(target_datetime) # one
  end

  test "should get new" do
    get new_commission_master_url
    assert_response :success
  end

  test "should create commission_master" do
    assert_difference("CommissionMaster.count") do
      post commission_masters_url, params: { commission_master:
        { commission_fee: @additional_commission_master.commission_fee, from_date: @additional_commission_master.from_date, to_date: @additional_commission_master.to_date }
       }
    end

    assert_redirected_to commission_master_url(CommissionMaster.last)
  end

  test "should show commission_master" do
    get commission_master_url(@commission_master)
    assert_response :success
  end

  test "should get edit" do
    get edit_commission_master_url(@commission_master)
    assert_response :success
  end

  test "should update commission_master" do
    patch commission_master_url(@commission_master), params: { commission_master:
      { commission_fee: @commission_master.commission_fee, from_date: @commission_master.from_date, to_date: @commission_master.to_date }
     }
    assert_redirected_to commission_master_url(@commission_master)
  end

  test "should destroy commission_master" do
    commission_master = commission_masters(:destroy_target)
    assert_difference("CommissionMaster.count", -1) do
      delete commission_master_url(commission_master)
    end

    assert_redirected_to commission_masters_url
  end
end
