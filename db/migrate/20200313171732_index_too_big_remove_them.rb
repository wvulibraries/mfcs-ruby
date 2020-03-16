class IndexTooBigRemoveThem < ActiveRecord::Migration[5.2]
  def change
    remove_index :forms, :fields
    remove_index :forms, :navigation
    remove_index :forms, :permissions
  end
end
