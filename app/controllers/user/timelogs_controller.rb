# frozen_string_literal: true

class User::TimelogsController < ApplicationController
  before_action :authorize_user
  before_action :set_project, only: [:index, :new, :create]
  before_action :set_timelog, only: %i[show edit update destroy]
  before_action :set_comments, only: [:show]
  before_action :revert_hours, only: [:destroy]

  def index
    @timelogs = @project.timelogs.order(:created_at).page(params[:page])
  end

  def show
  end

  def new
    @timelog = Timelog.new
  end

  def edit
    @project = @timelog.project
    respond_to do |format|
      format.js
    end
  end

  def create
    @timelog = Timelog.new(timelog_params)
    @timelog.creator = current_user
    if @timelog.end_time < @timelog.start_time
      @timelog.errors.add(:end_time, 'must be greater than start time')
    else
      @timelog.hours = TimeDifference.between(@timelog.start_time, @timelog.end_time).in_hours.to_i unless @timelog.start_time.blank?
      @timelog.project = @project
      if @timelog.save
        set_hours
      end
    end
  end

  def update
    if @timelog.update(timelog_params)
      revert_hours
      update_hours
      set_hours
    end
  end

  def destroy
    @project = @timelog.project
    @timelog.destroy
  end

  private

  def set_timelog
    @timelog = Timelog.find_by_id(params[:id])
    render file: 'public/404.html', status: :not_found, layout: false unless @timelog
  end

  def set_project
    @project = Project.find(params[:project_id])
  end
  def set_comments
    @comments = @timelog.comments.order(updated_at: :desc)
  end

  def timelog_params
    params.require(:timelog).permit(:title, :description, :employee_id, :start_time, :end_time)
  end

  def update_hours
    @timelog.update(hours: TimeDifference.between(@timelog.start_time, @timelog.end_time).in_hours.to_i)
  end

  def set_hours
    hours = @timelog.project.hours_worked
    hours += @timelog.hours
    @timelog.project.update(hours_worked: hours)
  end

  def revert_hours
    hours = @timelog.project.hours_worked
    hours -= @timelog.hours
    @timelog.project.update(hours_worked: hours)
  end

  def authorize_user
    authorize User, :check_user?, policy_class: UserPolicy
  end
end
