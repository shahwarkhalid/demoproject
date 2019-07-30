require 'test_helper'

class Manager::ClientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @manager_client = manager_clients(:one)
  end

  test "should get index" do
    get manager_clients_url
    assert_response :success
  end

  test "should get new" do
    get new_manager_client_url
    assert_response :success
  end

  test "should create manager_client" do
    assert_difference('Manager::Client.count') do
      post manager_clients_url, params: { manager_client: { email: @manager_client.email, first_name: @manager_client.first_name, last_name: @manager_client.last_name, phone_no: @manager_client.phone_no } }
    end

    assert_redirected_to manager_client_url(Manager::Client.last)
  end

  test "should show manager_client" do
    get manager_client_url(@manager_client)
    assert_response :success
  end

  test "should get edit" do
    get edit_manager_client_url(@manager_client)
    assert_response :success
  end

  test "should update manager_client" do
    patch manager_client_url(@manager_client), params: { manager_client: { email: @manager_client.email, first_name: @manager_client.first_name, last_name: @manager_client.last_name, phone_no: @manager_client.phone_no } }
    assert_redirected_to manager_client_url(@manager_client)
  end

  test "should destroy manager_client" do
    assert_difference('Manager::Client.count', -1) do
      delete manager_client_url(@manager_client)
    end

    assert_redirected_to manager_clients_url
  end
end
