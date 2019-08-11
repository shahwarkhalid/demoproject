# frozen_string_literal: true

class Attachment < ApplicationRecord
  belongs_to :project
  belongs_to :creator, class_name: 'User'
  mount_uploader :attachment, AttachmentUploader

  validates_presence_of :attachment
  validates_presence_of :name
end
