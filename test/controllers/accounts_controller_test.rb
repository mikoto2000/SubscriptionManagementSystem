require "test_helper"

class AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account = accounts(:one)
  end

  test "should get index" do
    get accounts_url
    assert_response :success
  end

  test "should get index find by id" do
    get accounts_url, params: { q: { id_eq: @account.id } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr:nth-of-type(1) > td", text: @account.id.to_s
  end
  test "should get index search name" do
    search_string = @account.name
    get accounts_url, params: { q: { name_cont: search_string } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: search_string # one
  end

  test "should get index search name, multi hit" do
    search_string = "o" # `o`ne, tw`o`, destr`o`y_target.
    get accounts_url, params: { q: { name_cont: search_string } }
    assert_response :success

    assert_select "table > tbody > tr", count: 3
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: accounts(:one).name # one
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: accounts(:two).name # two
    assert_select "table > tbody > tr > td:nth-of-type(2)", text: accounts(:destroy_target).name # destroy_target
  end
  test "should get index search email_address" do
    search_string = @account.email_address
    get accounts_url, params: { q: { email_address_cont: search_string } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: search_string # one
  end

  test "should get index search email_address, multi hit" do
    search_string = "o" # `o`ne, tw`o`, destr`o`y_target.
    get accounts_url, params: { q: { email_address_cont: search_string } }
    assert_response :success

    assert_select "table > tbody > tr", count: 3
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: accounts(:one).name # one
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: accounts(:two).name # two
    assert_select "table > tbody > tr > td:nth-of-type(3)", text: accounts(:destroy_target).name # destroy_target
  end
  test "should get index search publishers" do
    search_ids = [accounts(:one).publisher, accounts(:two).publisher]
    get accounts_url, params: { q: { publisher_id_in: search_ids } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: @account.publisher.name # one
    assert_select "table > tbody > tr > td:nth-of-type(4)", text: @account.publisher.name # two
  end
  test "should get index search subscribers" do
    search_ids = [accounts(:one).subscriber, accounts(:two).subscriber]
    get accounts_url, params: { q: { subscriber_id_in: search_ids } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(5)", text: @account.subscriber.name # one
    assert_select "table > tbody > tr > td:nth-of-type(5)", text: @account.subscriber.name # two
  end

  test "should get index search created_at single hit" do
    target_datetime = @account.created_at
    get accounts_url, params: { q: {
      created_at_gteq: target_datetime,
      created_at_lteq_end_of_minute: target_datetime
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(6)", text: I18n.l(target_datetime) # one
  end

  test "should get index search created_at, multi hit" do
    target_datetime_from = accounts(:one).created_at
    target_datetime_to = accounts(:two).created_at
    get accounts_url, params: { q: {
      created_at_gteq: target_datetime_from,
      created_at_lteq_end_of_minute: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(6)", text: I18n.l(target_datetime_from) # one
    assert_select "table > tbody > tr > td:nth-of-type(6)", text: I18n.l(target_datetime_to) # two
  end

  test "should get index search updated_at" do
    target_datetime = @account.updated_at
    get accounts_url, params: { q: {
      updated_at_gteq: target_datetime,
      updated_at_lteq_end_of_minute: target_datetime
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 1
    assert_select "table > tbody > tr > td:nth-of-type(7)", text: I18n.l(target_datetime) # one
  end

  test "should get index search updated_at, multi hit" do
    target_datetime_from = accounts(:one).updated_at
    target_datetime_to = accounts(:two).updated_at
    get accounts_url, params: { q: {
      updated_at_gteq: target_datetime_from,
      updated_at_lteq_end_of_minute: target_datetime_to
    } }
    assert_response :success

    assert_select "table > tbody > tr", count: 2
    assert_select "table > tbody > tr > td:nth-of-type(7)", text: I18n.l(target_datetime_from) # one
    assert_select "table > tbody > tr > td:nth-of-type(7)", text: I18n.l(target_datetime_to) # two
  end

  test "should get new" do
    get new_account_url
    assert_response :success
  end

  test "should create account" do
    assert_difference("Account.count") do
      post accounts_url, params: { account:
        { email_address: @account.email_address, name: @account.name, publisher_id: @account.publisher_id, subscriber_id: @account.subscriber_id }
       }
    end

    assert_redirected_to account_url(Account.last)
  end

  test "should show account" do
    get account_url(@account)
    assert_response :success
  end

  test "should get edit" do
    get edit_account_url(@account)
    assert_response :success
  end

  test "should update account" do
    patch account_url(@account), params: { account:
      { email_address: @account.email_address, name: @account.name, publisher_id: @account.publisher_id, subscriber_id: @account.subscriber_id }
     }
    assert_redirected_to account_url(@account)
  end

  test "should destroy account" do
    account = accounts(:destroy_target)
    assert_difference("Account.count", -1) do
      delete account_url(account)
    end

    assert_redirected_to accounts_url
  end
end
