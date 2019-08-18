# frozen_string_literal: true

class Admin::TimelogsController < ApplicationController
  before_action :authorize_user
  before_action :set_project, only: [:index, :new, :create]
  before_action :set_timelog, only: %i[show edit update destroy]
  before_action :set_comments, only: [:show]
  before_action :convert_string_to_datetime, only: [:create, :update]

  def index
    @timelogs = @project.timelogs.order(:created_at).page(params[:page])
  end

  def show
  end

  def new
    @timelog = Timelog.new
  end

  def edit
    @timelog.start_time = ''
    @timelog.end_time = ''
    @project = @timelog.project
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
        Timelog.set_hours(@timelog)
      end
    end
  end

  def update
    if @timelog.update(timelog_params)
      Timelog.update_project_hours(@timelog)
    end
  end

  def destroy
    Timelog.revert_hours(@timelog)
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

  def authorize_user
    authorize User, :check_admin?, policy_class: UsersPolicy
  end

  def convert_string_to_datetime
    params[:timelog][:start_time] = DateTime.strptime(params[:timelog][:start_time], '%m/%d/%Y %I:%M %p') if !params[:timelog][:start_time].blank?
    params[:timelog][:end_time] = DateTime.strptime(params[:timelog][:end_time], '%m/%d/%Y %I:%M %p') if !params[:timelog][:end_time].blank?
  end
end
