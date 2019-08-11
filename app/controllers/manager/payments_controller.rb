# frozen_string_literal: true

class Manager::PaymentsController < PaymentsController
  #before_action :authorize_user
  before_action :revert_amount, only: [:destroy]
  def index
    super
    authorize User, :check_manager?, policy_class: ManagersPolicy
  end

  def show
    super
    authorize User, :check_manager?, policy_class: ManagersPolicy
  end

  def new
    super
    authorize User, :check_manager?, policy_class: ManagersPolicy
    respond_to do |format|
      format.js
    end
  end

  def edit
    super
    authorize User, :check_manager?, policy_class: ManagersPolicy
    respond_to do |format|
      format.js
    end
  end

  def create
    authorize User, :check_manager?, policy_class: ManagersPolicy
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
    authorize User, :check_manager?, policy_class: ManagersPolicy
    @project = @payment.project
    super
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to manager_project_payments_url(@payment.project), notice: 'Payment was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  def search
    @projects = Project.search_projects(params[:name]).order(:created_at).page(params[:page])
    respond_to do |format|
      format.js
    end
  end

  private

  def set_project
    @project = Project.find_by_id(params[:id])
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
