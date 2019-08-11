# frozen_string_literal: true

class AttachmentsController < ApplicationController
  def new
    @attachment = Attachment.new
  end

  def create
    @attachment = Attachment.new(attachment_params)
    @attachment.creator = current_user
    @attachment.save
  end

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy
  end

  private

  def attachment_params
    params.permit(:attachment, :name, :project_id)
  end
end
