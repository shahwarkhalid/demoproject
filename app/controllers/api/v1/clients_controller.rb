# frozen_string_literal: true

class Api::V1::ClientsController < ApiController
  before_action :set_client, only: %i[show]
  before_action :authorise_user

  def index
    render json: Client.search_clients(params)
  end

  def show
    render json: @client
  end

  private

  def set_client
    @client = Client.find_by_id(params[:id])
    render json: 'record not found', status: :not_found unless @client
  end

  def authorise_user
    render json: 'you are not authorised to access' if current_user.user?
  end
end
