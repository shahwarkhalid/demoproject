# frozen_string_literal: true

class Admin::PaymentsController < PaymentsController
  def index
    authorize User, :check_admin?, policy_class: UsersPolicy
    super
  end

  def show
    authorize User, :check_admin?, policy_class: UsersPolicy
    super
  end

  def new
    authorize User, :check_admin?, policy_class: UsersPolicy
    super
  end

  def edit
    authorize User, :check_admin?, policy_class: UsersPolicy
    super
    respond_to do |format|
      format.js
    end
  end

  def create
    authorize User, :check_admin?, policy_class: UsersPolicy
    @project = Project.find(params[:project_id])
    @payment = Payment.new(payment_params)
    @payment.project_id = params[:project_id]
    @payment.creator = current_user
    respond_to do |format|
      if @payment.save
        # format.html { redirect_to admin_project_payments_url(params[:project_id]), notice: 'Payment was successfully created.' }
        # format.json { render :show, status: :created, location: @admin_project_payments_url }
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
    authorize User, :check_admin?, policy_class: UsersPolicy
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to admin_project_payments_url(@payment.project), notice: 'Payment was successfully updated.' }
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
    super
    authorize User, :check_admin?, policy_class: UsersPolicy
    @project = @payment.project
    @payment.destroy
    respond_to do |format|
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
