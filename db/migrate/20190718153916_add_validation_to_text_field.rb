class AddValidationToTextField < ActiveRecord::Migration[5.2]
  def change
    add_column :text_fields, :validation, :string
    add_column :text_fields, :validation_regex, :string
  end
end
