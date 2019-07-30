# frozen_string_literal: true

class CreateManagerClients < ActiveRecord::Migration[5.2]
  def change
    create_table :manager_clients do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone_no
      t.string :email

      t.timestamps
    end
  end
end
