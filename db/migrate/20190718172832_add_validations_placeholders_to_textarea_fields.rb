class AddValidationsPlaceholdersToTextareaFields < ActiveRecord::Migration[5.2]
  def change
    add_column :textarea_fields, :validation, :string
    add_column :textarea_fields, :validation_regex, :string
  end
end
