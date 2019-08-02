class AddReferencesToTimelogs < ActiveRecord::Migration[5.2]
  def change
    add_reference :timelogs, :employee, class_name: 'User'
    add_reference :timelogs, :project
    add_reference :timelogs, :creator, class_name: 'User'
  end
end
