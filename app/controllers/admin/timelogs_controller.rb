# frozen_string_literal: true

class Admin::TimelogsController < ApplicationController
  before_action :set_timelog, only: %i[show edit update destroy]

  def index
    @project = Project.find(params[:project_id])
    @timelogs = @project.timelogs.order(:created_at).page(params[:page])
  end

  def show; end

  def new
    @project = Project.find(params[:project_id])
    @timelog = Timelog.new
  end

  def edit
    @project = @timelog.project
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
      else
        format.html { render :edit }
        format.json { render json: @timelog.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @timelog.destroy
    respond_to do |format|
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

  def timelog_params
    params.require(:timelog).permit(:title, :description, :employee_id, :start_time, :end_time)
  end
end
