class CreateTimelogs < ActiveRecord::Migration[5.2]
  def change
    create_table :timelogs do |t|
      t.string :title
      t.text :description
      t.datetime :start_time
      t.datetime :end_time
      t.integer :hours

      t.timestamps
    end
  end
end
