class AddColumnToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :source_id, :bigint
  end
end
