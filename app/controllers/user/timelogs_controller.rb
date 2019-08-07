# frozen_string_literal: true

class User::TimelogsController < ApplicationController
  before_action :set_timelog, only: %i[show edit update destroy]
  before_action :set_comments, only: [:show]
  before_action :revert_hours, only: [:destroy]

  def index
    authorize User, :check_user?, policy_class: UserPolicy
    @project = Project.find(params[:project_id])
    @timelogs = @project.timelogs.order(:created_at).page(params[:page])
  end

  def show
    authorize User, :check_user?, policy_class: UserPolicy
  end

  def new
    authorize User, :check_user?, policy_class: UserPolicy
    @project = Project.find(params[:project_id])
    @timelog = Timelog.new
    respond_to do |format|
      format.js
    end
  end

  def edit
    authorize User, :check_user?, policy_class: UserPolicy
    @project = @timelog.project
    respond_to do |format|
      format.js
    end
  end

  def create
    authorize User, :check_user?, policy_class: UserPolicy
    @timelog = Timelog.new(timelog_params)
    @timelog.creator_id = current_user.id
    @timelog.hours = TimeDifference.between(@timelog.start_time, @timelog.end_time).in_hours.to_i unless @timelog.start_time.blank?
    @timelog.project_id = params[:project_id]
    respond_to do |format|
      if @timelog.save
        set_hours
        format.html { redirect_to user_project_timelogs_url(params[:project_id]), notice: 'Timelog was successfully created.' }
        format.json { render :show, status: :created, location: @timelog }
        format.js
      else
        format.html { render :new }
        format.json { render json: @timelog.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def update
    authorize User, :check_user?, policy_class: UserPolicy
    respond_to do |format|
      if @timelog.update(timelog_params)
        revert_hours
        update_hours
        set_hours
        format.html { redirect_to user_project_timelogs_url(@timelog.project_id), notice: 'Timelog was successfully updated.' }
        format.json { render :show, status: :ok, location: @timelog }
        format.js
      else
        format.html { render :edit }
        format.json { render json: @timelog.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def destroy
    authorize User, :check_user?, policy_class: UserPolicy
    @project = @timelog.project
    @timelog.destroy
    respond_to do |format|
      format.js
      format.html { redirect_to user_project_timelogs_url(@timelog.project_id), notice: 'Timelog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def search
    @timelogs = Timelog.search_Timelogs(params[:name]).order(:created_at).page(params[:page])
    respond_to do |format|
      format.js
    end
  end

  private

  def set_timelog
    @timelog = Timelog.find_by_id(params[:id])
    render file: 'public/404.html', status: :not_found, layout: false unless @timelog
  end

  def set_comments
    timelog = Timelog.find(params[:id])
    @comments = timelog.comments.order(updated_at: :desc)
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
end
