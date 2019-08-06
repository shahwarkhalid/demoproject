# frozen_string_literal: true

class Admin::ProjectsController < ProjectsController
  def index
    super
    authorize User, :check_admin?, policy_class: UsersPolicy
  end

  def show
    authorize User, :check_admin?, policy_class: UsersPolicy
  end

  def new
    super
    authorize User, :check_admin?, policy_class: UsersPolicy
  end

  def edit
    super
    authorize User, :check_admin?, policy_class: UsersPolicy
  end

  def create
    authorize User, :check_admin?, policy_class: UsersPolicy
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
    authorize User, :check_admin?, policy_class: UsersPolicy
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
    authorize User, :check_admin?, policy_class: UsersPolicy
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

  def assign_employees
    authorize User, :check_admin?, policy_class: UsersPolicy
    super
  end

  def create_employees_list
    authorize User, :check_admin?, policy_class: UsersPolicy
    project = Project.find(params[:project_id])
    add_employees_by_emails(project) if emails?
    domains_emplist = get_domains_emplist if domain?
    add_employees_by_domains(domains_emplist, project) if domain?
    redirect_to admin_projects_url, notice: 'Employees were successfully assigned'
  end

  def emplist
    super
  end

  private

  def set_project
    @project = Project.find_by_id(params[:id])
    render file: 'public/404.html', status: :not_found, layout: false unless @project
  end

  def project_params
    params.require(:project).permit(:title, :description, :total_hours, :budget, :manager_id, :client_id)
  end

  def add_employees_by_emails(project)
    params[:employees].shift if emails?
    emails_emplist = params[:employees]
    emps = User.find(emails_emplist)
    emps.each do |emp|
      project.employees << emp unless EmployeesProject.exists?(employee_id: emp.id, project_id: project.id)
    end
  end

  def add_employees_by_domains(emplist, project)
    emplist.each do |emp|
      project.employees << emp unless EmployeesProject.exists?(employee_id: emp.id, project_id: project.id)
    end
  end

  def get_domains_emplist
    domains_list = params[:domains]
    domains_list = domains_list.gsub(/\n/, '')
    domains_list = domains_list.gsub(/\r/, '')
    domains_list = domains_list.split(',')
    domains_list = User.domains_emails(domains_list)
    employees = domains_list
  end

  def emails?
    params[:add_by_email] == '1'
  end

  def domain?
    params[:add_by_domain] == '1'
  end
end
