# frozen_string_literal: true

class Api::V1::TimelogsController < ApiController
  before_action :authorise_user
  before_action :set_project, only: %i[index create]
  before_action :set_timelog, only: %i[show update destroy]
  before_action :convert_string_to_datetime, only: %i[create update]
  before_action :authorise_user_for_project, only: [:index], if: :user?
  before_action :authorize_request

  def index
    render json: Timelog.get_timelogs(@project, current_user)
  end

  def show
    render json: @timelog
  end

  def create
    @timelog = Timelog.new(timelog_params)
    @timelog.creator = current_user
    if @timelog.end_time < @timelog.start_time
      @timelog.errors.add(:end_time, 'must be greater than start time')
    else
      @timelog.hours = TimeDifference.between(@timelog.start_time, @timelog.end_time).in_hours.to_i unless @timelog.start_time.blank?
      @timelog.project = @project
      Timelog.set_hours(@timelog) if @timelog.save
    end
    render json: @timelog.errors.any? ? @timelog.errors : @timelog
  end

  def update
    Timelog.update_project_hours(@timelog) if @timelog.update(timelog_params)
    render json: @timelog.errors.any? ? @timelog.errors : @timelog
  end

  def destroy
    Timelog.revert_hours(@timelog)
    @timelog.destroy
    render json: 'Timelog was destroyed'
  end

  private

  def set_timelog
    @timelog = Timelog.find_by_id(params[:id])
    render json: 'record not found', status: :not_found unless @timelog
  end

  def set_project
    @project = Project.find_by_id(params[:project_id])
    render json: 'record not found', status: :not_found unless @project
  end

  def timelog_params
    params.permit(:title, :description, :employee_id, :start_time, :end_time)
  end

  def authorise_user
    render json: 'you are not authorised to access' if current_user.manager?
  end

  def convert_string_to_datetime
    params[:start_time] = DateTime.strptime(params[:start_time], '%m/%d/%Y %I:%M %p') unless params[:start_time].blank?
    params[:end_time] = DateTime.strptime(params[:end_time], '%m/%d/%Y %I:%M %p') unless params[:end_time].blank?
  end

  def authorise_user_for_project
    render json: 'you are not authorised to access' unless Project.valid_project?(@project, current_user)
  end

  def user?
    current_user.user?
  end

end
