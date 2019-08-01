class Project < ApplicationRecord
  has_many :employees_projects
  has_many :employees, :through => :employees_projects, class_name: 'User'
end
