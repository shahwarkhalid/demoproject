# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[edit update destroy]
  before_action :set_commentable, only: %i[edit update destroy]

  def edit
  end

  def create
    @comment = Comment.new(comment_params)
    set_commentable
    @comment.creator = current_user
    @comment.save
  end

  def update
    @comment.update(update_params)
  end

  def destroy
    @comment.destroy
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_commentable
    @commentable = @comment.commentable
  end

  def comment_params
    params.permit(:text, :commentable_type, :commentable_id)
  end

  def update_params
    params.require(:comment).permit(:text, :commentable_type, :commentable_id)
  end
end
