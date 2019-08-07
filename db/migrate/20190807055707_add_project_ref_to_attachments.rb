class AddProjectRefToAttachments < ActiveRecord::Migration[5.2]
  def change
    add_reference :attachments, :project, foreign_key: true
  end
end
