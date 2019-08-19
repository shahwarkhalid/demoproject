# frozen_string_literal: true

class Api::V1::PaymentsController < ApiController
  before_action :authorise_user
  before_action :set_payment, only: %i[show update destroy]
  before_action :set_project, only: %i[index new]

  def index
    render json: Payment.get_payments(@project)
  end

  def show
    render json: @payment
  end

  def create
    set_project
    @payment = Payment.new(payment_params)
    @payment.project = @project
    @payment.creator = current_user
    Payment.set_amount(@payment) if @payment.save
    render json: @payment.errors.any? ? @payment.errors : @payment
  end

  def update
    Payment.revert_amount(@payment)
    Payment.set_amount(@payment) if @payment.update(payment_params)
    render json: @payment.errors.any? ? @payment.errors : @payment
  end

  def destroy
    Payment.revert_amount(@payment)
    @payment.destroy
    render json: 'payment was destroyed'
  end

  private

  def set_payment
    @payment = Payment.find_by_id(params[:id])
    render json: 'record not found', status: :not_found unless @payment
  end

  def set_project
    @project = Project.find_by_id(params[:project_id])
    render json: 'record not found', status: :not_found unless @project
  end

  def payment_params
    params.permit(:title, :payment_type, :amount)
  end

  def authorise_user
    render json: 'you are not authorised to access' if current_user.user?
  end
end
