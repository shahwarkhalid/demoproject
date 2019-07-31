class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.string :payment_type
      t.decimal :amount, precision: 5, scale: 2
      t.bigint :created_by

      t.timestamps
    end
  end
end
