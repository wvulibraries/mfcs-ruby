class AdjustJsonToArrays < ActiveRecord::Migration[5.2]
  def change
    # remove columns and indexes 
    remove_column :forms, :fields
    remove_column :forms, :permissions
    remove_column :forms, :idno
    remove_column :forms, :navigation

    # add columns
    add_column :forms, :fields, :jsonb, null: true, array: true, default: []
    add_column :forms, :navigation, :jsonb, null: true, array: true, default: []
    add_column :forms, :idno, :jsonb, null: true, array: true, default: []
    add_column :forms, :permissions, :jsonb, null: true, array: true, default: []

    # add indexes 
    add_index :forms, :fields
    add_index :forms, :navigation
    add_index :forms, :idno
    add_index :forms, :permissions
  end
end
