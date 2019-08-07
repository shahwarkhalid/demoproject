# frozen_string_literal: true

class AttachmentsController < ApplicationController
  def index
    @attachments = Attachment.all
  end

  def new
    @project_id = params[:project_id]
    @attachment = Attachment.new
    respond_to do |format|
      format.js
    end
  end

  def create
    @attachment = Attachment.new(attachment: params[:attachment], project_id: params[:project_id], creator_id: current_user.id)
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
