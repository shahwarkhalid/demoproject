class AddReferenceToPayments < ActiveRecord::Migration[5.2]
  def change
    add_reference :payments, :creator, class_name: 'User'
  end
end
