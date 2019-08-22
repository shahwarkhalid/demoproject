# frozen_string_literal: true

class Timelog < ApplicationRecord
  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :employee, class_name: 'User'
  belongs_to :project
  belongs_to :creator, class_name: 'User'

  validates_presence_of :title
  validates :start_time, presence: true, timeliness: { type: :datetime }
  validates :end_time, presence: true, timeliness: { type: :datetime }
  validate :start_time_cannot_be_greater_than_end_time
  paginates_per 5

  before_update :update_hours
  after_save :set_hours
  before_destroy :revert_hours

  def self.get_timelogs(project, user)
    timelogs = project.timelogs.includes(:creator)
    timelogs = timelogs.where(creator_id: user.id) if user.user?
    timelogs.order(:created_at)
  end

  def set_hours
    hours = self.project.hours_worked
    hours += self.hours
    self.project.update(hours_worked: hours)
  end

  def revert_hours
    hours = self.project.hours_worked
    hours -= self.hours
    self.project.update(hours_worked: hours)
  end

  def update_hours
    hours = self.project.hours_worked
    hours -= self.hours_was
    self.project.update(hours_worked: hours)
  end

  def self.monthly_stats
    self.where('year(start_time) = ?', "#{Date.today.year}").group("date_format(start_time, '%M')").sum(:hours)
  end

  def start_time_cannot_be_greater_than_end_time
    if start_time > end_time
      errors.add(:end_time, "cannot be less than start time")
    end
  end
end
