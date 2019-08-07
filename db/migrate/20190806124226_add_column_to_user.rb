# frozen_string_literal: true

class AddColumnToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :image, :string
  end
end
