class AddBooleansToFields < ActiveRecord::Migration[5.2]
  def change
    add_column :fields, :required, :boolean
    add_column :fields, :no_duplicates, :boolean
    add_column :fields, :read_only, :boolean
    add_column :fields, :disabled, :boolean
    add_column :fields, :disabled_on_insert, :boolean
    add_column :fields, :public_release, :boolean
    add_column :fields, :oai_release, :boolean
    add_column :fields, :sortable, :boolean
    add_column :fields, :searchable, :boolean
    add_column :fields, :display_in_list, :boolean
    add_column :fields, :hidden, :boolean
  end
end
