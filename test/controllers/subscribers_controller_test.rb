require "test_helper"

class SubscribersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @subscriber = subscribers(:one)
    @additional_subscriber = Subscriber.new({
      :name => "additional",
      :email_address => "additional@example.com"
    })
  end

  test "should get index" do
    get subscribers_url
    assert_response :success
  end

  test "should get index find by id" do
    get subscribers_url, params: { q: { id_eq: @subscriber.id } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr:nth-of-type(1) > td", text: @subscriber.id.to_s
  end
  test "should get index search name" do
    search_string = @subscriber.name
    get subscribers_url, params: { q: { name_cont: search_string } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: search_string # one
  end

  test "should get index search name, multi hit" do
    search_string = "o" # all com.
    get subscribers_url, params: { q: { name_cont: search_string } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: subscribers(:one).name # one
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: subscribers(:two).name # two
  end
  test "should get index search email_address" do
    search_string = @subscriber.email_address
    get subscribers_url, params: { q: { email_address_cont: search_string } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: search_string # one
  end

  test "should get index search email_address, multi hit" do
    search_string = "o" # all com.
    get subscribers_url, params: { q: { email_address_cont: search_string } }
    assert_response :success

    assert_select "table > tbody > tr", count: 4
  end

  test "should get index search created_at single hit" do
    target_datetime = @subscriber.created_at
    get subscribers_url, params: { q: {
      created_at_gteq: target_datetime,
      created_at_lteq_end_of_minute: target_datetime
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: I18n.l(target_datetime) # one
  end

  test "should get index search created_at, multi hit" do
    target_datetime_from = subscribers(:one).created_at
    target_datetime_to = subscribers(:two).created_at
    get subscribers_url, params: { q: {
      created_at_gteq: target_datetime_from,
      created_at_lteq_end_of_minute: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: I18n.l(target_datetime_from) # one
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: I18n.l(target_datetime_to) # two
  end

  test "should get index search updated_at" do
    target_datetime = @subscriber.updated_at
    get subscribers_url, params: { q: {
      updated_at_gteq: target_datetime,
      updated_at_lteq_end_of_minute: target_datetime
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(5)", text: I18n.l(target_datetime) # one
  end

  test "should get index search updated_at, multi hit" do
    target_datetime_from = subscribers(:one).updated_at
    target_datetime_to = subscribers(:two).updated_at
    get subscribers_url, params: { q: {
      updated_at_gteq: target_datetime_from,
      updated_at_lteq_end_of_minute: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(5)", text: I18n.l(target_datetime_from) # one
    assert_select "table > tbody > tr > td:nth-of-type(5)", text: I18n.l(target_datetime_to) # two
  end

  test "should get new" do
    get new_subscriber_url
    assert_response :success
  end

  test "should create subscriber" do
    assert_difference("Subscriber.count") do
      post subscribers_url, params: { subscriber:
        { email_address: @additional_subscriber.email_address, name: @additional_subscriber.name }
       }
    end

    assert_redirected_to subscriber_url(Subscriber.last)
  end

  test "should show subscriber" do
    get subscriber_url(@subscriber)
    assert_response :success
  end

  test "should get edit" do
    get edit_subscriber_url(@subscriber)
    assert_response :success
  end

  test "should update subscriber" do
    patch subscriber_url(@subscriber), params: { subscriber:
      { email_address: @subscriber.email_address, name: @subscriber.name }
     }
    assert_redirected_to subscriber_url(@subscriber)
  end

  test "should destroy subscriber" do
    subscriber = subscribers(:destroy_target)
    assert_difference("Subscriber.count", -1) do
      delete subscriber_url(subscriber)
    end

    assert_redirected_to subscribers_url
  end
end
