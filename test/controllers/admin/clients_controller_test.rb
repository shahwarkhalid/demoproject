require 'test_helper'

class Admin::ClientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_client = admin_clients(:one)
  end

  test "should get index" do
    get admin_clients_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_client_url
    assert_response :success
  end

  test "should create admin_client" do
    assert_difference('Admin::Client.count') do
      post admin_clients_url, params: { admin_client: { email: @admin_client.email, first_name: @admin_client.first_name, last_name: @admin_client.last_name, phone_no: @admin_client.phone_no } }
    end

    assert_redirected_to admin_client_url(Admin::Client.last)
  end

  test "should show admin_client" do
    get admin_client_url(@admin_client)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_client_url(@admin_client)
    assert_response :success
  end

  test "should update admin_client" do
    patch admin_client_url(@admin_client), params: { admin_client: { email: @admin_client.email, first_name: @admin_client.first_name, last_name: @admin_client.last_name, phone_no: @admin_client.phone_no } }
    assert_redirected_to admin_client_url(@admin_client)
  end

  test "should destroy admin_client" do
    assert_difference('Admin::Client.count', -1) do
      delete admin_client_url(@admin_client)
    end

    assert_redirected_to admin_clients_url
  end
end
