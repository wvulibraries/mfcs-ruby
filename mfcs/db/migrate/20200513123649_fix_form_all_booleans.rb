class FixFormAllBooleans < ActiveRecord::Migration[6.0]
  def change
    change_column :forms, :container, :boolean, default: false, null: false
    change_column :forms, :export_oai, :boolean, default: false, null: false
    change_column :forms, :export_public, :boolean, default: false, null: false
    change_column :forms, :object_public_release_default, :boolean, default: false, null: false
    change_column :forms, :object_public_release_show, :boolean, default: false, null: false
    change_column :forms, :production, :boolean, default: false, null: false
  end
end
