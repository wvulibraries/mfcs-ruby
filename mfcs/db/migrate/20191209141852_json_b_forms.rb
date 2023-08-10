class JsonBForms < ActiveRecord::Migration[5.2]
  def change
    remove_column :forms, :fields
    add_column :forms, :fields, :jsonb, null: false, default: {}
  end
end
