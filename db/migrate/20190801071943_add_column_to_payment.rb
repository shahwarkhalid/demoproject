class AddColumnToPayment < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :title, :string
  end
end
