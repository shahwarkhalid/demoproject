# frozen_string_literal: true

require 'application_system_test_case'

class Manager::ClientsTest < ApplicationSystemTestCase
  setup do
    @manager_client = manager_clients(:one)
  end

  test 'visiting the index' do
    visit manager_clients_url
    assert_selector 'h1', text: 'Manager/Clients'
  end

  test 'creating a Client' do
    visit manager_clients_url
    click_on 'New Manager/Client'

    fill_in 'Email', with: @manager_client.email
    fill_in 'First name', with: @manager_client.first_name
    fill_in 'Last name', with: @manager_client.last_name
    fill_in 'Phone no', with: @manager_client.phone_no
    click_on 'Create Client'

    assert_text 'Client was successfully created'
    click_on 'Back'
  end

  test 'updating a Client' do
    visit manager_clients_url
    click_on 'Edit', match: :first

    fill_in 'Email', with: @manager_client.email
    fill_in 'First name', with: @manager_client.first_name
    fill_in 'Last name', with: @manager_client.last_name
    fill_in 'Phone no', with: @manager_client.phone_no
    click_on 'Update Client'

    assert_text 'Client was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Client' do
    visit manager_clients_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Client was successfully destroyed'
  end
end
