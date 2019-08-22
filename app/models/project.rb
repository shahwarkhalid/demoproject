# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :employees_projects
  has_many :employees, through: :employees_projects, class_name: 'User', dependent: :destroy
  belongs_to :client
  has_many :payments, dependent: :destroy
  has_many :timelogs, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :manager, class_name: 'User'
  belongs_to :creator, class_name: 'User'
  has_many :attachments

  validates_presence_of :title, :hours_worked
  validates :total_hours, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than: 0 }
  paginates_per 5

  def self.search_admin_projects
    projects = self.includes(:creator, :manager, :client)
  end

  def self.search_manager_projects(current_user)
    projects = Project.where(manager: current_user).or(Project.where(creator: current_user)).includes(:creator, :manager, :client)
  end

  def self.search_employee_projects(current_user)
    projects = current_user.projects.includes(:creator, :manager, :client)
  end

  def self.search_projects(params, current_user)
    projects = search_admin_projects if current_user.admin?
    projects = search_manager_projects(current_user) if current_user.manager?
    projects = search_employee_projects(current_user) if current_user.user?
    projects = projects.where('title LIKE ?', "%#{params[:name]}%") if params[:name].present?
    projects.order(:created_at)
  end

  def self.top_projects
    projects = all.order(budget: :desc).limit(5)
  end

  def self.bottom_projects
    projects = all.order(budget: :asc).limit(5)
  end

  def self.build_employees_projects(employee_list, project)
    #emps = User.find(emails_emplist)
    employee_list.each do |emp|
      next if emp.present?
      EmployeesProject.find_or_create_by(employee_id: emp, project_id: project.id)
    end
  end

  # def self.add_employees_by_emails_api(project, params)
  #   emails_emplist = JSON.parse(params[:employees])
  #   Project.build_employees_projects(emails_emplist, project)
  # end

  # def self.add_employees_by_emails(project, params)
  #   params[:employees].shift
  #   emails_emplist = params[:employees]
  #   Project.build_employees_projects(emails_emplist, project)
  # end

  def self.manager_top_projects(current_user)
    projects = Project.where(manager: current_user).or(Project.where(creator: current_user)).order(budget: :desc).limit(5)
  end

  def self.get_employees(project, params)
    project.employees.order(:id).page(params[:page])
  end

  def self.valid_project?(project, current_user)
    if current_user.user?
      EmployeesProject.exists?(employee: current_user, project: project)
    elsif current_user.manager?
      project.manager == current_user
    end
  end
end
