# frozen_string_literal: true

class Admin::TimelogsController < ApplicationController
  before_action :set_timelog, only: %i[show edit update destroy]
  before_action :set_comments, only: [:show]
  def index
    @project = Project.find(params[:project_id])
    @timelogs = @project.timelogs.order(:created_at).page(params[:page])
  end

  def show; end

  def new
    @project = Project.find(params[:project_id])
    @timelog = Timelog.new
    respond_to do |format|
      format.js
    end
  end

  def edit
    @project = @timelog.project
    respond_to do |format|
      format.js
    end
  end

  def create
    @timelog = Timelog.new(timelog_params)
    @timelog.creator_id = current_user.id
    @timelog.hours = TimeDifference.between(@timelog.start_time, @timelog.end_time).in_hours.to_i
    @timelog.project_id = params[:project_id]
    respond_to do |format|
      if @timelog.save
        format.html { redirect_to admin_project_timelogs_url(params[:project_id]), notice: 'Timelog was successfully created.' }
        format.json { render :show, status: :created, location: @timelog }
        format.js
      else
        format.html { render :new }
        format.json { render json: @timelog.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @timelog.update(timelog_params)
        format.html { redirect_to admin_project_timelogs_url(@timelog.project_id), notice: 'Timelog was successfully updated.' }
        format.json { render :show, status: :ok, location: @timelog }
        format.js
      else
        format.html { render :edit }
        format.json { render json: @timelog.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project = @timelog.project
    @timelog.destroy
    respond_to do |format|
      format.js
      format.html { redirect_to admin_project_timelogs_url(@timelog.project_id), notice: 'Timelog was successfully destroyed.' }
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
end
