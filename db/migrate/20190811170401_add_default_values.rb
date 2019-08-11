class AddDefaultValues < ActiveRecord::Migration[5.2]
  def change
    change_column_default :projects, :budget, 0
    change_column_default :projects, :hours_worked, 0
  end
end
