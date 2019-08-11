# frozen_string_literal: true

class PaymentsController < ApplicationController
  before_action :set_payment, only: %i[show edit update destroy]
  before_action :set_project, only: %i[index new]
  before_action :set_comments, only: [:show]

  def index
    @payments = @project.payments.order(:created_at).page(params[:page])
  end

  def show; end

  def new
    @payment = Payment.new(project_id: params[:project_id])
  end

  def edit; end

  def create; end

  def update; end

  def destroy; end

  private

  def set_payment
    @payment = Payment.find_by_id(params[:id])
    render file: 'public/404.html', status: :not_found, layout: false unless @payment
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_comments
    @comments = @payment.comments.order(updated_at: :desc)
  end

  def payment_params
    params.require(:payment).permit(:title, :description, :total_hours, :budget, :manager_id, :client_id)
  end
end
