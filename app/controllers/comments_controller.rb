# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[show edit update destroy]
  before_action :set_commentable, only: %i[show edit update destroy]
  def index; end

  def show; end

  def new; end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def create
    @comment = Comment.new(comment_params)
    set_commentable
    @comment.creator_id = current_user.id
    if @comment.save
      respond_to do |format|
        format.js
      end
    end
  end

  def update
    if @comment.update(update_params)
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.js
    end
  end

  def search; end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_commentable
    @commentable = Project.find(@comment.commentable_id) if @comment.commentable_type == 'Project'
    @commentable = Payment.find(@comment.commentable_id) if @comment.commentable_type == 'Payment'
    @commentable = Timelog.find(@comment.commentable_id) if @comment.commentable_type == 'Timelog'
  end

  def comment_params
    params.permit(:text, :commentable_type, :commentable_id)
  end

  def update_params
    params.require(:comment).permit(:text, :commentable_type, :commentable_id)
  end
end
