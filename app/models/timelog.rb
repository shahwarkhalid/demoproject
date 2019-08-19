# frozen_string_literal: true

class Timelog < ApplicationRecord
  has_many :comments, as: :commentable
  belongs_to :employee, class_name: 'User'
  belongs_to :project
  belongs_to :creator, class_name: 'User'

  validates_presence_of :title
  validates :start_time, presence: true, timeliness: { type: :datetime }
  validates :end_time, presence: true, timeliness: { type: :datetime }

  paginates_per 5

  def self.get_timelogs(project, user)
    timelogs = project.timelogs
    timelogs = timelogs.where(employee_id: user.id) if user.user?
    timelogs.order(:created_at)
  end

  def self.update_hours(timelog)
    timelog.update(hours: TimeDifference.between(timelog.start_time, timelog.end_time).in_hours.to_i)
  end

  def self.set_hours(timelog)
    hours = timelog.project.hours_worked
    hours += timelog.hours
    timelog.project.update(hours_worked: hours)
  end

  def self.revert_hours(timelog)
    hours = timelog.project.hours_worked
    hours -= timelog.hours
    timelog.project.update(hours_worked: hours)
  end

  def self.update_project_hours(timelog)
    revert_hours(timelog)
    update_hours(timelog)
    set_hours(timelog)
  end
end
