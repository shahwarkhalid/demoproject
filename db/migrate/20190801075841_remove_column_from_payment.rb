class RemoveColumnFromPayment < ActiveRecord::Migration[5.2]
  def change
    remove_column :payments, :created_by, :bigint
  end
end
