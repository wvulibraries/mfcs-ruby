class CreateForms < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
    create_table :forms do |t|
      t.string :title
      t.text :description
      t.hstore :fields
      t.string :idno
      t.boolean :container
      t.boolean :production
      t.boolean :metadata
      t.boolean :export_public
      t.boolean :export_oai
      t.boolean :object_public_release_show
      t.boolean :object_public_release_default
      t.string :submit_button
      t.string :update_button
      t.integer :count
      t.string :display_title
      t.string :object_title_field
      t.hstore :navigation
      t.string :link_title
      t.timestamps
    end
    add_index :forms, :fields, using: :gin
    add_index :forms, :navigation, using: :gin
    add_index :forms, :idno, unique: true
    add_index :forms, :title, unique: true
    add_index :forms, :display_title, unique: true
  end
end
