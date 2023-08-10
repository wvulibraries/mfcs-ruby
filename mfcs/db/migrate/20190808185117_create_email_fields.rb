class CreateEmailFields < ActiveRecord::Migration[5.2]
  def change
    create_table :email_fields do |t|
      t.string :name
      t.string :label
      t.string :value
      t.string :css_id
      t.string :css_class
      t.string :local_styles
      t.string :help_type
      t.string :help_info
      t.string :type
      t.boolean :required
      t.boolean :no_duplicates
      t.boolean :read_only
      t.boolean :disabled
      t.boolean :disabled_on_insert
      t.boolean :public_release
      t.boolean :oai_release
      t.boolean :sortable
      t.boolean :searchable
      t.boolean :display_in_list
      t.boolean :hidden
      t.integer :format
      t.string :placeholder
      t.integer :position
      t.string :validation
      t.timestamps
    end
  end
end
