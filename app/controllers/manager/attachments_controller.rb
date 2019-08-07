class Manager::AttachmentsController < ApplicationController
  def index
    @attachments = Attachment.all
  end

  def new
    @attachment = Attachment.new
    respond_to do |format|
      format.js
    end
  end

  def create
    @attachment = Attachment.new
    @attachment.attachment = params[:attachment]
    @attachment.project_id = 1
    respond_to do |format|
      if @attachment.save
        format.js
      else
        format.js
      end
    end
  end

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy
    respond_to do |format|
      format.js
    end
  end

  private

  def attachment_params
    params.permit(:attachment)
  end
end
