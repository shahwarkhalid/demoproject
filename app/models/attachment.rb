# frozen_string_literal: true

class Attachment < ApplicationRecord
  mount_uploader :attachment, AttachmentUploader
  belongs_to :project
  belongs_to :creator, class_name: 'User'
end
