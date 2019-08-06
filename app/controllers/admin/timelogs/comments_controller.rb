# frozen_string_literal: true

class Admin::Timelogs::CommentsController < ApplicationController
  before_action :set_comment, only: %i[show edit update destroy]

  def index
    @timelog = Timelog.find(params[:timelog_id])
    @comments = @timelog.comments
  end

  def edit; end

  def create
    timelog = Timelog.find(params[:timelog_id])
    comment = Comment.new(text: params[:text], commentable: timelog)
    comment.creator_id = current_user.id
    respond_to do |format|
      if comment.save
        format.html { redirect_to admin_timelog_comments_url(params[:timelog_id]), notice: 'Comment was successfully added.' }
      else
        format.html { render :index }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to admin_timelog_comments_url(params[:timelog_id]), notice: 'Comment was successfully updated.' }
      else
        format.html { render :index }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to admin_timelog_comments_url(@comment.commentable_id), notice: 'Comment was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def search; end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:text)
  end
end
