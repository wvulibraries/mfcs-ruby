class RemoveTitleIndex < ActiveRecord::Migration[5.2]
  def change
    remove_index :forms, :title
  end
end
