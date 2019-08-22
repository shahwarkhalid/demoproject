# frozen_string_literal: true

class Admin::TimelogsController < ApplicationController
  before_action :authorize_user
  before_action :set_project, only: %i[index new create]
  before_action :set_timelog, only: %i[show edit update destroy]
  before_action :set_comments, only: [:show]
  before_action :convert_string_to_datetime, only: %i[create update]
  before_action :calculate_hours, only: [:create, :update]

  def index
    @timelogs = Timelog.get_timelogs(@project, current_user).page(params[:page])
  end

  def show; end

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
    @timelog.project = @project
    @timelog.save
  end

  def update
    @timelog.update(timelog_params)
  end

  def destroy
    @project = @timelog.project
    @timelog.destroy
  end

  private

  def set_timelog
    @timelog = Timelog.find(params[:id])
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_comments
    @comments = Comment.get_comments(@timelog)
  end

  def timelog_params
    params.require(:timelog).permit(:title, :description, :employee_id, :start_time, :end_time, :hours)
  end

  def authorize_user
    authorize User, :check_admin?, policy_class: UsersPolicy
  end

  def convert_string_to_datetime
    params[:timelog][:start_time] = DateTime.strptime(params[:timelog][:start_time], '%m/%d/%Y %I:%M %p') unless params[:timelog][:start_time].blank?
    params[:timelog][:end_time] = DateTime.strptime(params[:timelog][:end_time], '%m/%d/%Y %I:%M %p') unless params[:timelog][:end_time].blank?
  end

  def calculate_hours
    params[:timelog][:hours] = TimeDifference.between(params[:timelog][:start_time],params[:timelog][:end_time]).in_hours.to_i if params[:timelog][:start_time].present? && params[:timelog][:end_time].present?
  end
end
