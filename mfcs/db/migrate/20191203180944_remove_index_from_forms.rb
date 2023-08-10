class RemoveIndexFromForms < ActiveRecord::Migration[5.2]
  def change
    remove_index :forms, :display_title
  end
end
