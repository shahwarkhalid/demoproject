class RemoveColumnsFromProject < ActiveRecord::Migration[5.2]
  def change
    remove_column :projects, :created_by, :bigint
    remove_column :projects, :manager_id, :bigint
  end
end
