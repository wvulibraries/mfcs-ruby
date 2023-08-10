class AddPermissionsToForms < ActiveRecord::Migration[5.2]
  def change
    add_column :forms, :permissions, :hstore
  end
end
