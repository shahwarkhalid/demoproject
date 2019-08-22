# frozen_string_literal: true

class PaymentsController < ApplicationController
  before_action :set_payment, only: %i[show edit update destroy]
  before_action :set_project, only: %i[index new]
  before_action :set_comments, only: [:show]

  def index
    @payments = Payment.get_payments(@project).page(params[:page])
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
    @payment = Payment.find(params[:id])
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_comments
    @comments = Comment.get_comments(@payment)
  end

  def payment_params
    params.require(:payment).permit(:title, :payment_type, :amount)
  end
end
