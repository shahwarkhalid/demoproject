# frozen_string_literal: true

json.array! @admin_clients, partial: 'admin_clients/admin_client', as: :admin_client
