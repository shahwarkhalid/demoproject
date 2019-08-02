# frozen_string_literal: true

class Project < ApplicationRecord
  validates_presence_of :title
  validates_presence_of :total_hours
  validates_presence_of :hours_worked
  validates :budget, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than: 0, less_than: 10000 }

  has_many :employees_projects
  has_many :employees, through: :employees_projects, class_name: 'User'
  belongs_to :client
  has_many :payments
  has_many :timelogs
  belongs_to :manager, class_name: 'User'
  belongs_to :creator, class_name: 'User'
  paginates_per 5
end
