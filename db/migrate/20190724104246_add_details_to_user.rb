# frozen_string_literal: true

class AddDetailsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string
    add_column :users, :role, :string
    add_column :users, :status, :boolean
    add_column :users, :age, :integer
    add_column :users, :address, :string
  end
end
