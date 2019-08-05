class CommentsController < ApplicationController
  before_action :set_comment, only: %i[show edit update destroy]

  def index
  end

  def show; end

  def new
  end

  def edit; end

  def create
    comment = Comment.new(comment_params)
    if comment.save
      respond_to do |format|
        format.js
      end
    end
  end

  def update; end

  def destroy; end

  def search
  end

  private

  def set_comment
  end

  def comment_params
    params.require(:comment).permit(:text, :commentable_type, :commentable_id)
  end
end
