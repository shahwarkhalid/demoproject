class AddReferenceToComment < ActiveRecord::Migration[5.2]
  def change
    add_reference :comments, :creator, class_name: 'User'
  end
end
