# frozen_string_literal: true

class Timelog < ApplicationRecord
  belongs_to :employee, class_name: 'User'
  belongs_to :project
  belongs_to :creator, class_name: 'User'
  has_many :comments, as: :commentable
  paginates_per 5
end
