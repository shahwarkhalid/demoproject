class Admin::Projects::CommentsController < CommentsController
  before_action :set_comment, only: %i[show edit update destroy]

  def index
    @project = Project.find(params[:project_id])
    @comments = ProjectsComment.where(source_id: params[:project_id])
  end

  def edit; end

  def create
    comment = ProjectsComment.new(text: params[:text])
    comment.source_id = params[:project_id]
    comment.creator_id = current_user.id
    respond_to do |format|
      if comment.save
        format.html { redirect_to admin_project_comments_url(params[:project_id]), notice: 'Comment was successfully added.' }
      else
        format.html { render :index }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to admin_project_comments_url(params[:project_id]), notice: 'Comment was successfully updated.' }
      else
        format.html { render :index }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to admin_project_comments_url(@comment.source_id), notice: 'Comment was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def search
  end

  private

  def set_comment
    @comment = ProjectsComment.find(params[:id])
  end

  def comment_params
    params.require(:projects_comment).permit(:text)
  end
end
