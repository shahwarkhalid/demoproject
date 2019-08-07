class AttachmentsController < ApplicationController
  def index
    @attachments = Attachment.all
  end

  def new
    @attachment = Attachment.new
  end

  def create
    @attachment = Attachment.new(attachment_params)
    @attachment.project_id = 1
    if @attachment.save
       redirect_to attachments_path, notice: "The Attachment has been uploaded."
    else
       render "new"
    end

  end

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy
    redirect_to Attachments_path, notice:  "The Attachment has been deleted."
  end

  private
    def attachment_params
    params.require(:attachment).permit(:attachment)
  end
end
