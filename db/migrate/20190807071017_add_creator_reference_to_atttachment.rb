class AddCreatorReferenceToAtttachment < ActiveRecord::Migration[5.2]
  def change
    add_reference :attachments, :creator, class_name: 'User'
  end
end
