# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.boolean :status
      t.integer :total_hours
      t.integer :hours_worked
      t.decimal :budget, precision: 5, scale: 2

      t.timestamps
    end
  end
end
