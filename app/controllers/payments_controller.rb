# frozen_string_literal: true

class PaymentsController < ApplicationController
  before_action :set_payment, only: %i[show edit update destroy]

  def index
    @project = Project.find(params[:project_id])
    @payments = @project.payments.order(:created_at).page(params[:page])
  end

  def show; end

  def new
    @project = Project.find(params[:project_id])
    @payment = Payment.new(project_id: params[:project_id])
  end

  def edit; end

  def create; end

  def update; end

  def destroy; end

  def search
    @payments = Payment.search_payments(params[:name]).order(:created_at).page(params[:page])
    respond_to do |format|
      format.js
    end
  end

  private

  def set_payment
    @payment = Payment.find_by_id(params[:id])
    render file: 'public/404.html', status: :not_found, layout: false unless @payment
  end

  def payment_params
    params.require(:payment).permit(:title, :description, :total_hours, :budget, :manager_id, :client_id)
  end
end
