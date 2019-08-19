class CreateMultiSelectFields < ActiveRecord::Migration[5.2]
  def change
    create_table :multi_select_fields do |t|
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
      t.integer :choice_type
      t.integer :choice_form_id
      t.integer :choice_form_field
      t.string :choices, array: true, default: []
      t.integer :default_choice
      t.timestamps
    end
  end
end
