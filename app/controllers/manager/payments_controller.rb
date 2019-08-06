# frozen_string_literal: true

class Manager::PaymentsController < PaymentsController
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
    @project = Project.find(params[:project_id])
    @payment = Payment.new(payment_params)
    @payment.project_id = params[:project_id]
    @payment.creator = current_user
    respond_to do |format|
      if @payment.save
        format.html { redirect_to manager_project_payments_url(params[:project_id]), notice: 'Payment was successfully created.' }
        format.json { render :show, status: :created, location: @admin_project_payments_url }
        format.js
      else
        format.html { render :new }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def update
    super
    authorize User, :check_manager?, policy_class: ManagersPolicy
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to manager_project_payments_url(@payment.project), notice: 'Payment was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment }
        format.js
      else
        format.html { render :edit }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
        format.js
      end
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
end
