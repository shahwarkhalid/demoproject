# frozen_string_literal: true

class Manager::ClientsController < ManagerController
  before_action :set_client, only: %i[show edit update destroy]

  def index
    @manager_clients = Client.all.order(:created_at).page(params[:page])
  end

  def show; end

  def new
    @manager_client = Client.new
  end

  def edit; end

  def create
    @manager_client = Client.new(client_params)

    respond_to do |format|
      if @manager_client.save
        format.html { redirect_to manager_client_url(@manager_client), notice: 'Client was successfully created.' }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @manager_client.update(client_params)
        format.html { redirect_to manager_client_url(@manager_client), notice: 'Client was successfully updated.' }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @manager_client.destroy
    respond_to do |format|
      format.html { redirect_to manager_clients_url, notice: 'Client was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def search
    @manager_clients = Client.search_clients(params[:name]).order(:created_at).page(params[:page])
    respond_to do |format|
      format.js
    end
  end

  private

  def set_client
    @manager_client = Client.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:first_name, :last_name, :phone_no, :email)
  end
end
