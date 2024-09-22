require "test_helper"

class PublishersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @publisher = publishers(:one)
  end

  test "should get index" do
    get publishers_url
    assert_response :success
  end

  test "should get index find by id" do
    get publishers_url, params: { q: { id_eq: @publisher.id } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr:nth-of-type(1) > td", text: @publisher.id.to_s
  end
  test "should get index search name" do
    search_string = @publisher.name
    get publishers_url, params: { q: { name_cont: search_string } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: search_string # one
  end

  test "should get index search name, multi hit" do
    search_string = "o" # `o`ne, tw`o`, destr`o`y_target.
    get publishers_url, params: { q: { name_cont: search_string } }
    assert_response :success

    assert_select "table > tbody > tr", count: 3
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: publishers(:one).name # one
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: publishers(:two).name # two
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: publishers(:destroy_target).name # destroy_target
  end
  test "should get index search email_address" do
    search_string = @publisher.email_address
    get publishers_url, params: { q: { email_address_cont: search_string } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: search_string # one
  end

  test "should get index search email_address, multi hit" do
    search_string = "o" # `o`ne, tw`o`, destr`o`y_target.
    get publishers_url, params: { q: { email_address_cont: search_string } }
    assert_response :success

    assert_select "table > tbody > tr", count: 3
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: publishers(:one).name # one
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: publishers(:two).name # two
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: publishers(:destroy_target).name # destroy_target
  end

  test "should get index search created_at single hit" do
    target_datetime = @publisher.created_at
    get publishers_url, params: { q: {
      created_at_gteq: target_datetime,
      created_at_lteq_end_of_minute: target_datetime
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: I18n.l(target_datetime) # one
  end

  test "should get index search created_at, multi hit" do
    target_datetime_from = publishers(:one).created_at
    target_datetime_to = publishers(:two).created_at
    get publishers_url, params: { q: {
      created_at_gteq: target_datetime_from,
      created_at_lteq_end_of_minute: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: I18n.l(target_datetime_from) # one
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: I18n.l(target_datetime_to) # two
  end

  test "should get index search updated_at" do
    target_datetime = @publisher.updated_at
    get publishers_url, params: { q: {
      updated_at_gteq: target_datetime,
      updated_at_lteq_end_of_minute: target_datetime
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(5)", text: I18n.l(target_datetime) # one
  end

  test "should get index search updated_at, multi hit" do
    target_datetime_from = publishers(:one).updated_at
    target_datetime_to = publishers(:two).updated_at
    get publishers_url, params: { q: {
      updated_at_gteq: target_datetime_from,
      updated_at_lteq_end_of_minute: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(5)", text: I18n.l(target_datetime_from) # one
    assert_select "table > tbody > tr > td:nth-of-type(5)", text: I18n.l(target_datetime_to) # two
  end

  test "should get new" do
    get new_publisher_url
    assert_response :success
  end

  test "should create publisher" do
    assert_difference("Publisher.count") do
      post publishers_url, params: { publisher:
        { email_address: @publisher.email_address, name: @publisher.name }
       }
    end

    assert_redirected_to publisher_url(Publisher.last)
  end

  test "should show publisher" do
    get publisher_url(@publisher)
    assert_response :success
  end

  test "should get edit" do
    get edit_publisher_url(@publisher)
    assert_response :success
  end

  test "should update publisher" do
    patch publisher_url(@publisher), params: { publisher:
      { email_address: @publisher.email_address, name: @publisher.name }
     }
    assert_redirected_to publisher_url(@publisher)
  end

  test "should destroy publisher" do
    publisher = publishers(:destroy_target)
    assert_difference("Publisher.count", -1) do
      delete publisher_url(publisher)
    end

    assert_redirected_to publishers_url
  end
end
