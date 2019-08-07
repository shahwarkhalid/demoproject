class Attachment < ApplicationRecord
  mount_uploader :attachment, AttachmentUploader
  belongs_to :project
end
