class RemoveIndex < ActiveRecord::Migration[5.2]
  def change
    remove_index :forms, :fields
  end
end
