class AddProjectRefToPayments < ActiveRecord::Migration[5.2]
  def change
    add_reference :payments, :project, foreign_key: true
  end
end
