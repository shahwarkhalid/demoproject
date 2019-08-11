# frozen_string_literal: true

class Timelog < ApplicationRecord
  has_many :comments, as: :commentable
  belongs_to :employee, class_name: 'User'
  belongs_to :project
  belongs_to :creator, class_name: 'User'

  validates_presence_of :title
  validates :start_time, presence: true, timeliness: {type: :datetime}
  validates :end_time, presence: true, timeliness: {type: :datetime}

  paginates_per 5
end
