# frozen_string_literal: true

class Admin::ProjectsController < ProjectsController
  def index
    super
  end

  def show; end

  def new
    super
  end

  def edit
    super
  end

  def create
    @project = Project.new(project_params)
    @project.creator_id = current_user.id
    @project.status = 1
    @project.hours_worked = 0
    respond_to do |format|
      if @project.save
        format.html { redirect_to admin_project_url(@project), notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @Project }
      else
        format.html { render :new }
        format.json { render json: @Project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    super
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to admin_project_url(@project), notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @Project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    super
    @project.destroy
    respond_to do |format|
      format.html { redirect_to admin_projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
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

  def project_params
    params.require(:project).permit(:title, :description, :total_hours, :budget, :manager_id, :client_id)
  end
end
