# frozen_string_literal: true

class Admin::PaymentsController < PaymentsController
  before_action :authorize_user
  before_action :revert_amount, only: [:destroy]
  def index
    super
  end

  def show
    super
  end

  def new
    super
  end

  def edit
    super
  end

  def create
    set_project
    @payment = Payment.new(payment_params)
    @payment.project = @project
    @payment.creator = current_user
    if @payment.save
      set_amount
    end
  end

  def update
    revert_amount
    if @payment.update(payment_params)
      set_amount
    end
  end

  def destroy
    @project = @payment.project
    @payment.destroy
  end

  private

  def authorize_user
    authorize User, :check_admin?, policy_class: UsersPolicy
  end

  def set_project
    @project = Project.find_by_id(params[:project_id])
    render file: 'public/404.html', status: :not_found, layout: false unless @project
  end

  def payment_params
    params.require(:payment).permit(:title, :payment_type, :amount)
  end

  def set_amount
    budget = @payment.project.budget
    budget += @payment.amount
    @payment.project.update(budget: budget)
  end

  def revert_amount
    budget = @payment.project.budget
    budget -= @payment.amount
    @payment.project.update(budget: budget)
  end
end
