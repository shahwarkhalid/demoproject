json.extract! manager_client, :id, :first_name, :last_name, :phone_no, :email, :created_at, :updated_at
json.url manager_client_url(manager_client, format: :json)
