# frozen_string_literal: true

class Admin::ClientsController < AdminController
  before_action :set_admin_client, only: %i[show edit update destroy]

  def index
    @admin_clients = Client.search_clients(params).page(params[:page])
  end

  def show; end

  def new
    @admin_client = Client.new
  end

  def edit; end

  def create
    @admin_client = Client.new(admin_client_params)

    respond_to do |format|
      if @admin_client.save
        format.html { redirect_to admin_client_url(@admin_client), notice: 'Client was successfully created.' }
        format.json { render :show, status: :created, location: @admin_client }
      else
        format.html { render :new }
        format.json { render json: @admin_client.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @admin_client.update(admin_client_params)
        format.html { redirect_to admin_client_url(@admin_client), notice: 'Client was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_client }
      else
        format.html { render :edit }
        format.json { render json: @admin_client.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @admin_client.destroy
    respond_to do |format|
      format.html { redirect_to admin_clients_url, notice: 'Client was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_admin_client
    @admin_client = Client.find(params[:id])
  end

  def admin_client_params
    params.require(:client).permit(:first_name, :last_name, :phone_no, :email)
  end

  def rescue_from_fk_contraint
    flash[:alert] = 'Cannot Delete This Client'
    redirect_to request.referrer
  end
end
