# frozen_string_literal: true

class CreateEmployeesProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :employees_projects, id: false do |t|
      t.belongs_to :employee, class_name: 'User'
      t.belongs_to :project
    end
  end
end
