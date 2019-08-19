# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :employees_projects
  has_many :employees, through: :employees_projects, class_name: 'User'
  belongs_to :client
  has_many :payments
  has_many :timelogs
  has_many :comments, as: :commentable
  belongs_to :manager, class_name: 'User'
  belongs_to :creator, class_name: 'User'
  has_many :attachments

  validates_presence_of :title, :total_hours, :hours_worked

  paginates_per 5

  def self.search_admin_projects(params)
    projects = all
    projects = projects.where('title LIKE ?', "%#{params[:name]}%") if params.key?(:name) && !params[:name].empty?
    projects.order(:created_at)
  end

  def self.search_manager_projects(params, current_user)
    projects = Project.where(manager_id: current_user.id).or(Project.where(creator_id: current_user.id))
    projects = projects.where('title LIKE ?', "%#{params[:name]}%") if params.key?(:name) && !params[:name].empty?
    projects.order(:created_at)
  end

  def self.search_employee_projects(params, current_user)
    projects = current_user.projects
    projects = projects.where('title LIKE ?', "%#{params[:name]}%") if params.key?(:name) && !params[:name].empty?
    projects.order(:created_at)
  end

  def self.search_projects(params, current_user)
    projects = search_admin_projects(params) if current_user.admin?
    projects = search_manager_projects(params, current_user) if current_user.manager?
    projects = search_employee_projects(params, current_user) if current_user.user?
    projects
  end

  def self.top_projects
    projects = all.order(budget: :desc).limit(5)
  end

  def self.bottom_projects
    projects = all.order(budget: :asc).limit(5)
  end

  def self.add_employees_by_emails(project, params)
    emails_emplist = JSON.parse(params[:employees])
    emps = User.find(emails_emplist)
    emps.each do |emp|
      EmployeesProject.find_or_create_by(employee_id: emp.id, project_id: project.id)
    end
  end
  def self.manager_top_projects(current_user)
    projects = Project.where(manager_id: current_user.id).or(Project.where(creator_id: current_user.id)).order(budget: :desc).limit(5)
  end
end
