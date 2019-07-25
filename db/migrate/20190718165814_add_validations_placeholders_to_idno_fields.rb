class AddValidationsPlaceholdersToIdnoFields < ActiveRecord::Migration[5.2]
  def change
    add_column :idno_fields, :validation, :string
    add_column :idno_fields, :validation_regex, :string
    add_column :idno_fields, :placeholder, :string
  end
end
