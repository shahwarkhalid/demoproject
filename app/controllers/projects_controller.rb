# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]

  def index
    @projects = Project.all.order(:created_at).page(params[:page])
  end

  def show; end

  def new
    @project = Project.new
  end

  def edit; end

  def create; end

  def update; end

  def destroy; end

  def search
    @projects = Project.search_projects(params[:name]).order(:created_at).page(params[:page])
    respond_to do |format|
      format.js
    end
  end

  def assign_employees
    @project = Project.find(params[:project_id])
  end

  def create_employees_list
  end

  def emplist
    project = Project.find(params[:project_id])
    @employees = project.employees.order(:id).page(params[:page])
  end
  private

  def set_project
    @project = Project.find_by_id(params[:id])
    render file: 'public/404.html', status: :not_found, layout: false unless @project
  end

  def project_params
    params.require(:project).permit(:title, :description, :total_hours, :budget, :manager_id, :client_id)
  end
end
