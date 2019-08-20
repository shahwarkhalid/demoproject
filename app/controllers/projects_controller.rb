# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]
  before_action :set_payments, only: [:show]
  before_action :set_timelogs, only: [:show]
  before_action :set_comments, only: [:show]
  before_action :set_attachments, only: [:show]

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
    @project = Project.find(params[:project_id])
  end

  def create_employees_list; end

  def employee_list
    project = Project.find(params[:project_id])
    @employees = project.employees.order(:id).page(params[:page])
  end

  private

  def set_project
    @project = Project.find_by_id(params[:id])
    render file: 'public/404.html', status: :not_found, layout: false unless @project
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
end
