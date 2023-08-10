class RemoveIndexForms < ActiveRecord::Migration[5.2]
  def change
    remove_index :forms, :idno
    drop_table :metadata_mappings
    drop_table :fields
  end
end
