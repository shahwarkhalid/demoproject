# frozen_string_literal: true

json.extract! admin_client, :id, :first_name, :last_name, :phone_no, :email, :created_at, :updated_at
json.url admin_client_url(admin_client, format: :json)
