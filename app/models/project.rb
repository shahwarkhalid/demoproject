# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :employees_projects
  has_many :employees, through: :employees_projects, class_name: 'User'
  belongs_to :client
  has_many :payments
  belongs_to :manager, class_name: 'User'
  belongs_to :creator, class_name: 'User'
  paginates_per 5
end
