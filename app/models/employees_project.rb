class EmployeesProject < ApplicationRecord
  belongs_to :employee, class_name: 'User'
  belongs_to :project
end
