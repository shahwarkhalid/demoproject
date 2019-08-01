class Project < ApplicationRecord
  has_many :employees_projects
  has_many :employees, :through => :employees_projects, class_name: 'User'
  belongs_to :client
  has_many :payments
end
