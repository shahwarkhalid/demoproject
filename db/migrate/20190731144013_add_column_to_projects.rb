# frozen_string_literal: true

class AddColumnToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :created_by, :bigint
    add_column :projects, :manager_id, :bigint
  end
end
