class Timelog < ApplicationRecord
  belongs_to :employee, class_name: 'User'
  belongs_to :project
  belongs_to :creator, class_name: 'User'
end
