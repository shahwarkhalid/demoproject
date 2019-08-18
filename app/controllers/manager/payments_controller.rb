# frozen_string_literal: true

class Manager::PaymentsController < PaymentsController
  before_action :authorize_user
  def index
    super
  end

  def show
  end

  def new
    super
  end

  def edit
  end

  def create
    set_project
    @payment = Payment.new(payment_params)
    @payment.project = @project
    @payment.creator = current_user
    if @payment.save
      Payment.set_amount(@payment)
    end
  end

  def update
    Payment.revert_amount(@payment)
    if @payment.update(payment_params)
      Payment.set_amount(@payment)
    end
  end

  def destroy
    Payment.revert_amount(@payment)
    @project = @payment.project
    @payment.destroy
  end

  private

  def authorize_user
    authorize User, :check_manager?, policy_class: ManagersPolicy
  end
end
