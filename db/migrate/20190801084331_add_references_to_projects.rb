class AddReferencesToProjects < ActiveRecord::Migration[5.2]
  def change
    add_reference :projects, :manager, class_name: 'User'
    add_reference :projects, :creator, class_name: 'User'
  end
end
