# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]
  before_action :set_payments, only: [:show]
  before_action :set_timelogs, only: [:show]
  before_action :set_comments, only: [:show]
  before_action :set_attachments, only: [:show]
  before_action :set_parent_project, only: [:employee_list, :assign_employees, :create_employees_list]

  def index; end

  def show; end

  def new
    @project = Project.new
  end

  def edit; end

  def create; end

  def update; end

  def destroy; end

  def assign_employees
  end

  def create_employees_list
    Project.add_employees_by_emails(@project, params)
  end

  def employee_list
    @employees = Project.get_employees(@project, params)
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def set_parent_project
    @project = Project.find(params[:project_id])
  end

  def set_payments
    @payments = Payment.get_payments(@project).page(params[:page])
  end

  def set_timelogs
    @timelogs = Timelog.get_timelogs(@project, current_user).page(params[:page])
  end

  def set_comments
    @comments = Comment.get_comments(@project)
  end

  def set_attachments
    @attachments = Attachment.get_attachments(@project)
  end

  def project_params
    params.require(:project).permit(:title, :description, :total_hours, :budget, :manager_id, :client_id)
  end

  def rescue_from_fk_contraint
    flash[:alert] = 'Cannot Delete This Project'
    redirect_to request.referrer
  end
end
